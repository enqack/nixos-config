{ config, pkgs, lib, disko, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/nvme0n1"; })

    ../../profiles/roles/laptop
  ];
  
  config = {
    networking = {
      hostName = "scalar";
    };

    virtualisation.containers.enable = true;

    services.xserver.videoDrivers = [ "intel" ];

    # boot.initrd.systemd.emergencyAccess = true;

    environment.systemPackages = with pkgs; [
      eslint
      obs-studio
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];
  };
}

