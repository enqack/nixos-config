{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "nesttest";
  };

  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix { device = "/dev/vda"; }

    ../../config/base/env.nix
    ../../config/base/nix.nix
    ../../config/base/networking.nix
    ../../config/base/packages.nix
    ../../config/base/users.nix

    ../../config/services/acpi.nix
    ../../config/services/logind.nix
    ../../config/services/nix-index.nix
    ../../config/services/plymouth.nix
    ../../config/services/ssh.nix
    ../../config/services/xserver.nix

    ../../config/system/auto-upgrade.nix
    ../../config/system/boot.nix
    ../../config/system/garbage-collection.nix
    ../../config/system/issue.nix
    ../../config/system/time.nix

    ../../config/filesystem/lvm.nix

    ../../config/ui/console.nix
    ../../config/ui/fonts.nix
  ];

  # Additional configurations that don’t fit specific module
  system.stateVersion = "24.05";
}

