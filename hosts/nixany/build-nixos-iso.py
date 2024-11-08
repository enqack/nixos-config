#!/usr/bin/env python3
import os
import subprocess
import re
import time
from concurrent.futures import ThreadPoolExecutor

import notify2

# Initialize notifications
notify2.init("BuildNixOS ISO")

# Define paths and constants
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
LOGFILE = os.path.join(SCRIPT_DIR, "iso_build_output.log")
WORKSTATION_IP = "192.168.10.20"
DEST_PATH = "~"

def send_notification(title, message):
    """Send a desktop notification using notify2."""
    n = notify2.Notification(title, message)
    n.show()

def build_iso():
    """Run the ISO build command and log output in real-time."""
    with open(LOGFILE, "w") as log_file:
        process = subprocess.Popen(
            ["nice", "-n", "19", "nix-build", "-j", "1", "<nixpkgs/nixos>",
             "-A", "config.system.build.isoImage", "-I", "nixos-config=./unattended-iso.nix"],
            cwd=os.path.expanduser("~/.config/nixos/hosts/nixany"),
            stdout=log_file,
            stderr=subprocess.STDOUT
        )
        process.communicate()

    send_notification("BuildNixOS ISO", "ISO build completed.")
    return parse_iso_path()

def parse_iso_path():
    """Extract the ISO path from the log file."""
    with open(LOGFILE, "r") as log_file:
        log_content = log_file.read()
    match = re.search(r'(/nix/store/[^ ]*-nixos-unattended-installer\.iso)', log_content)
    if match:
        iso_path = match.group(1) + "/iso/nixos-unattended-installer.iso"
        print(f"ISO created: {iso_path}")
        return iso_path
    else:
        print("ISO file path not found in output.")
        send_notification("BuildNixOS ISO", "ISO file path not found in output.")
        return None

def copy_iso_to_workstation(iso_path):
    """Upload ISO to the workstation."""
    try:
        subprocess.run(["ssh", WORKSTATION_IP, "rm -f ~/nixos-unattended-installer.iso"], check=True)
        subprocess.run(["scp", iso_path, f"{WORKSTATION_IP}:{DEST_PATH}"], check=True)
        print("ISO upload completed.")
        send_notification("BuildNixOS ISO", "ISO upload complete.")
    except subprocess.CalledProcessError:
        print("ISO upload failed.")
        send_notification("BuildNixOS ISO", "ISO upload failed.")

def monitor_log():
    """Monitor the log file for real-time updates and send notifications."""
    last_size = 0
    while True:
        current_size = os.path.getsize(LOGFILE)
        if current_size > last_size:
            with open(LOGFILE, "r") as f:
                f.seek(last_size)
                new_lines = f.readlines()
                for line in new_lines:
                    print(line.strip())
                    send_notification("Build Log Update", line.strip())
            last_size = current_size
        time.sleep(2)

def main():
    """Run the ISO build and monitor processes in parallel."""
    with ThreadPoolExecutor() as executor:
        iso_future = executor.submit(build_iso)
        executor.submit(monitor_log)

        # Wait for the ISO to be built
        iso_path = iso_future.result()
        if iso_path:
            copy_iso_to_workstation(iso_path)

if __name__ == "__main__":
    main()

