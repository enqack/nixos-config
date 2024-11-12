{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "nesttest";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/vda"; })

    ../../profiles/roles/server
  ];

  boot.kernelParams = [ "rd.auto" "root=/dev/mainpool/root" ];
  boot.initrd.systemd.emergencyAccess = true;
}

