{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "grillage";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/roles/server
  ];
}

