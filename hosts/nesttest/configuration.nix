{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "nesttest";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/vda"; })

    ../../profiles/roles/server
    ../../profiles/hardware/vm-guest
  ];

  boot.initrd.systemd.emergencyAccess = true;
  #systemd.services."emergency".serviceConfig.ExecStart = [ "/usr/lib/systemd/systemd-sulogin-shell emergency" ];
}

