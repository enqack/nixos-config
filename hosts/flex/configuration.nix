{ config, pkgs, lib, disko, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/roles/laptop
  ];
  
  config = {
    networking = {
      hostName = "flex";
    };

    boot.loader.efi.efiSysMountPoint = lib.mkForce "/boot";

    virtualisation.containers.enable = true;

    services.xserver.videoDrivers = [ "intel" ];

    nix.settings = {
      max-jobs = 1;
      cores = 1;
    };

    programs.wireshark.enable = true;
    #programs.wireshark.package = "wireshark-qt";

    modules.services.nix-index.enable = lib.mkForce false;

    # boot.initrd.systemd.emergencyAccess = true;

    environment.systemPackages = with pkgs; [
      eslint
      obs-studio
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];
  };
}

