{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "nixany";
  };

  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix

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

    ../../config/hardware/bluetooth.nix
    ../../config/hardware/graphics.nix
    ../../config/hardware/sound.nix

    ../../config/ui/console.nix
    ../../config/ui/fonts.nix

    ../../modules/users/skeleton
  ];

  # Additional configurations that don’t fit specific module
  system.stateVersion = "24.05";
}

