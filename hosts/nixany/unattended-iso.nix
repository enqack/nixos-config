{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];

  # Automatically enable SSH
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  # Define users and passwords
  users.users.root = {
    password = "root";
  };

  users.users.sysop = {
    isNormalUser = true;
    initialPassword = "sysop";
    extraGroups = [ "wheel" ]; # Grants sudo access
  };

  # Set up automatic disk partitioning, including EFI and swap
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    # EFI partition
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
      autoFormat = true;
      options = [ "rw" "relatime" ];
    };

    # Root partition
    "/" = {
      device = "/dev/sda2";
      fsType = "btfs";
      autoFormat = true;
    };
  };

  # Swap partition
  swapDevices = [
    {
      device = "/dev/sda3";
      autoFormat = true;
      size = 8192; # Set swap size in MiB
    }
  ];

  # Set hostname and other network settings
  networking.hostName = "nixany";

  # Add any additional packages you want preinstalled
  environment.systemPackages = with pkgs; [
    curl git gparted parted tmux vim wget
  ];
}
