#$ nice -n 19 nix-build -j 1 '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=./unattended-iso.nix
{ config, pkgs, lib, ... }:

let
  installerTargetTTY = "tty6";

  rootPassword = builtins.hashString "sha256" (toString builtins.currentTime);
  
  nixos-installer = pkgs.writeScriptBin "nixos-installer" ''
    #!/usr/bin/env python3

    import os
    import subprocess
    import sys
    import time
    import argparse
    import shutil

    # ANSI escape codes for colored output
    RESET_COLOR = "\033[0m"
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    CYAN = "\033[96m"

    def color_print(message, color=RESET_COLOR):
        """Prints a message in the specified color."""
        print(f"{color}{message}{RESET_COLOR}")

    def find_first_available_disk():
        """Finds the first available disk, skipping floppies and mounted disks."""
        result = subprocess.run(
            ["lsblk", "-pln", "-o", "NAME,TYPE"], 
            capture_output=True, text=True
        )
        for line in result.stdout.splitlines():
            device, dtype = line.split()
            if dtype != "disk" or device == "/dev/fd0":
                continue
            mount_check = subprocess.run(
                ["grep", "-ql", f"^{device}", "/proc/mounts"],
                capture_output=True
            )
            if mount_check.returncode != 0:  # Disk is not mounted
                return device
        return None

    def run_command(command, env=None, check=True):
        """Runs a shell command with optional environment variables."""
        color_print(f"Running command: {' '.join(command)}", CYAN)
        result = subprocess.run(command, env=env)
        if check and result.returncode != 0:
            color_print(f"ERROR: Command failed: {' '.join(command)}", RED)
            sys.exit(1)

    def find_disko_path():
        """Attempts to find the path to the 'disko' binary."""
        # Check if 'disko' is available in PATH
        disko_path = shutil.which("disko")
        if disko_path:
            return disko_path

        # Attempt to locate disko in the Nix store
        nix_disko_path = subprocess.run(
            ["find", "/nix/store", "-name", "disko", "-type", "f"],
            capture_output=True, text=True
        )
        if nix_disko_path.stdout:
            return nix_disko_path.stdout.strip()

        color_print("ERROR: 'disko' binary not found.", RED)
        sys.exit(1)

    def main(device_main, no_reboot):
        # Find disko path
        disko_path = find_disko_path()
        
        # Determine target disk from argument or find first available disk
        if not device_main:
            color_print("No disk specified, searching for first available disk...", YELLOW)
            device_main = find_first_available_disk()
            if not device_main:
                color_print("ERROR: No usable disk found on this machine!", RED)
                sys.exit(1)
            color_print(f"Found available disk: {device_main}", GREEN)
        else:
            color_print(f"Using specified disk: {device_main}", GREEN)
        
        # Erase the disk
        color_print(f"Erasing {device_main}...", YELLOW)
        run_command(["wipefs", "-a", device_main])

        # Run disko to partition and format the disk
        env = os.environ.copy()
        env["DISKO_DEVICE_MAIN"] = device_main
        env["NIX_PATH"] = os.getenv('NIX_PATH')
        run_command([
            disko_path,  # Using dynamically detected disko path
            "--mode", "disko", "/etc/nixos/disko-configuration.nix",
            "--argstr", "device", device_main
        ], env=env)

        # Copy configuration.nix
        color_print("Copying configuration.nix...", YELLOW)
        os.makedirs("/mnt/etc/nixos", exist_ok=True)
        run_command(["cp", "/etc/nixos/configuration.nix", "/mnt/etc/nixos/configuration.nix"])

        # Generate hardware-configuration.nix
        color_print("Generating hardware-configuration.nix...", YELLOW)
        run_command(["nixos-generate-config", "--root", "/mnt"])

        # Install the system
        color_print("Installing the system...", YELLOW)
        install_cmd = [
            "nixos-install", "--no-channel-copy", "--no-root-password",
            "--option", "substituters", ""
        ]
        try:
            run_command(install_cmd)
            color_print("Installation successful!", GREEN)
            if not no_reboot:
                color_print("Rebooting in 30 seconds...", YELLOW)
                time.sleep(30)
                run_command(["reboot"])
            else:
                color_print("Reboot skipped due to --no-reboot option.", YELLOW)
        except subprocess.CalledProcessError:
            color_print("ERROR: nixos-install failed. Please check logs for details.", RED)
            sys.exit(1)

    if __name__ == "__main__":
        # Argument parsing setup
        parser = argparse.ArgumentParser(description="NixOS Installer Script with Disk Selection")
        parser.add_argument(
            "disk", nargs="?", default=None,
            help="Specify the target disk for installation (e.g., /dev/sda). If not provided, the first available disk will be used."
        )
        parser.add_argument(
            "--no-reboot", action="store_true",
            help="Disable automatic reboot after installation."
        )
        args = parser.parse_args()
        main(args.disk, args.no_reboot)

  '';
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
  ];

  isoImage = {
    isoName = lib.mkForce "nixos-unattended-installer.iso";
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "zstd -Xcompression-level 14"; # Faster compression
  };

  environment.etc."issue" = {
    text = ''

       This is \l on \n.\o (\s \m \r)

       This in an installer image. It is desinged to wipe the first drive it finds
       DESTROYING ALL YOUR DATA. You'll have NixOS though.

       You may specify a device or let the installer find one to use.

       Run `sudo nixos-installer /dev/sda` or just `sudo nixos-installer` to procced.

       Alternatively, you can log in on tty6 and the instaler will auto-start.

       sysop:sysop@localhost

    '';
  };

  nixpkgs.overlays = [
    (final: prev: {
      nixos-installer = final.getExec nixos-installer;
    })
  ];

  # Set hostname
  networking.hostName = "nixany-installer";

  environment.systemPackages = with pkgs; [
    btrfs-progs
    cryptsetup
    curl
    dosfstools
    disko
    e2fsprogs
    efibootmgr
    efitools
    efivar
    git
    gnugrep
    gparted
    grub2_efi
    inotify-tools
    nixos-install-tools
    nixos-installer
    parted
    python3
    tmux
    vim
    util-linux
    wget
  ];

  console = {
    earlySetup = true;
    font = "ter-v32n";
    packages = [ pkgs.terminus_font ];
  };

  environment.etc."nixos/disko-configuration.nix".source = ./disko-configuration.nix;
  environment.etc."nixos/configuration.nix".source = ./unattended-configuration.nix;

  environment.shellInit = ''
    # Use the TARGET_TTY variable if set, otherwise fall back to actual TTY
    CURRENT_TTY=''${TARGET_TTY:-$(tty | sed 's:/dev/::')}
    
    # Only run if CURRENT_TTY matches the target
    if [ "$CURRENT_TTY" = "${installerTargetTTY}" ]; then
        echo "Starting NixOS installer on $CURRENT_TTY in 10 seconds..."
        sleep 10
        sudo nixos-installer
    else
        echo "Logged into $CURRENT_TTY. No installer started."
    fi
  '';
  
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  networking.dhcpcd.enable = true;
  
  users.users.root = {
    password = rootPassword;
  };

  users.users.sysop = {
    isNormalUser = true;
    password = "sysop";
    extraGroups = [ "wheel" ]; # Grants sudo access
  };

  services.getty.autologinUser = lib.mkForce "sysop";

  system.activationScripts.ensurePackagesCached = lib.mkForce ''
    # Cache all packages in systemPackages
    for pkg in ${lib.concatStringsSep " " (map (pkg: "${pkg}") config.environment.systemPackages)}; do
      nix-store -r "$pkg"
    done

    # Run garbage collection to clean up unused packages
    nix-collect-garbage -d
  '';

  system.stateVersion = "24.05";
}
