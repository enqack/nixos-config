{ config, pkgs, lib, disko, ... }:

{
  networking = {
    hostName = "flex";
  };

  imports = [
    ./hardware-configuration.nix
    # (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/roles/laptop
  ];

  virtualisation.containers.enable = true;

  services.xserver.videoDrivers = [ "intel" ];

  nix.settings = {
    max-jobs = 1;
    cores = 1;
  };

  boot.kernelParams = [
    "rd.systemd.log_level=debug"
    "rd.debug"
  ];

  boot.initrd.systemd.emergencyAccess = true;
}

