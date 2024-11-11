{ config, pkgs, disko, ... }:

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
}

