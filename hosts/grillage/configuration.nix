{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "grillage";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/roles/server

    ../../modules/nestops/cardinal/dhcpd
  ];

  systemd.network.networks."10-enp" = {
    matchConfig.Name = "enp*";
    networkConfig = {
      Address = "192.168.10.6/24";
      Gateway = "192.168.10.1";
      DNS = [ "192.168.10.1" "1.1.1.1" "8.8.8.8" ];
    };
  };

  nestops.cardinal.dhcpd = true;  
}

