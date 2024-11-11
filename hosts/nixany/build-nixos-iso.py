#!/usr/bin/env python3

import os
import subprocess
import re
import time
import logging
from concurrent.futures import ThreadPoolExecutor

# Configure logging to syslog and console for better tracking in systemd
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s - %(message)s'
)

def log_message(message):
    logging.info(message)

# Define paths and constants
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
WORKSTATION_IP = "192.168.10.20"
DEST_PATH = "~"

def parse_iso_path(log_content):
    """Extract the ISO path from build output."""
    match = re.search(r"Writing to 'stdio:([^']+)'", log_content)
    if match:
        return match.group(1)  # Extracted ISO path
    else:
        log_message("ISO path not found in build output.")
        return None

def build_iso():
    """Run the ISO build command and log output in real-time."""
    process = subprocess.Popen(
        ["nice", "-n", "19", "nix-build", "-j", "1", "<nixpkgs/nixos>",
         "-A", "config.system.build.isoImage", "-I", "nixos-config=./unattended-iso.nix"],
        cwd=os.path.expanduser("~/.config/nixos/hosts/nixany"),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )

    log_content = []  # Store log output for parsing ISO path later

    # Capture and log each line of output
    for line in iter(process.stdout.readline, b''):
        decoded_line = line.decode().strip()
        log_message(decoded_line)
        log_content.append(decoded_line)  # Collect lines for ISO path parsing

    process.stdout.close()
    process.wait()

    # Parse the ISO path from collected log content
    return parse_iso_path("\n".join(log_content))

def copy_iso_to_workstation(iso_path):
    """Upload ISO to the workstation with real-time progress logging."""
    try:
        log_message("ISO upload starting.")

        # Remove any existing ISO on the workstation
        subprocess.run(["ssh", WORKSTATION_IP, "rm -f ~/nixos-unattended-installer.iso"], check=True)

        # Copy new ISO to the workstation with verbose output for progress tracking
        process = subprocess.Popen(
            ["rsync", "--outbuf=L", iso_path, f"{WORKSTATION_IP}:{DEST_PATH}"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT  # Combine stdout and stderr for unified output
        )

        # Capture both stdout and stderr in real-time
        for line in iter(process.stdout.readline, b''):
            log_message(line.decode().strip())

        process.stdout.close()
        process.wait()

        if process.returncode == 0:
            log_message("ISO upload completed.")
        else:
            log_message("ISO upload failed.")
    except subprocess.CalledProcessError:
        log_message("ISO upload failed.")


def main():
    """Run the ISO build and upload in parallel."""
    with ThreadPoolExecutor() as executor:
        iso_future = executor.submit(build_iso)

        # Wait for the ISO to be built
        iso_path = iso_future.result()
        if iso_path:
            copy_iso_to_workstation(iso_path)
            log_message(f"Full ISO path: {iso_path}")

if __name__ == "__main__":
    main()


