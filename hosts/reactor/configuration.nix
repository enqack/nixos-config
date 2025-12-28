{ config, pkgs, lib, disko, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { rootfs = "/dev/nvme2n1"; homefs = "/dev/nvme1n1"; })

    ../../profiles/roles/workstation
    
    ../../profiles/software/python
    ../../profiles/software/steam    
    
  ];
  
  config = {
    networking = {
      hostName = "reactor";
    };

    virtualisation.containers.enable = true;

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_15;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;

    # boot.initrd.systemd.emergencyAccess = true;

    environment.systemPackages = with pkgs; [
      eslint
      obs-studio
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];
  };
}

