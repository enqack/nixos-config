{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "reactor";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/roles/workstation
  ];
}

