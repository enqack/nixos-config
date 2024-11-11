{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "vector";
  };

  imports = [
    ./hardware-configuration.nix
    # (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/roles/laptop
    ../../profiles/roles/workstation
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
}

