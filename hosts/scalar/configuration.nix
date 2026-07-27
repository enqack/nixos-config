{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/nvme0n1"; })

    ../../profiles/linux/roles/laptop

    ../../profiles/shared/software/python
    ../../profiles/linux/software/dms-greeter
  ];

  config = {
    networking = {
      hostName = "scalar";
    };

    modules.services.nixos-updates.enable = lib.mkForce false;
    modules.system.boot.grubGfxMode = "2560x1440,1920x1080,auto";

    distro-grub-themes = {
      enable = true;  
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
