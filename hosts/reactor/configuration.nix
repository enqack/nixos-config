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
      dhcpcd = {
        enable = true;
        denyInterfaces = [ "enp4s0" "br0" ];
      };
    };

    systemd.network = {
      enable = true;
      netdevs."20-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
          MACAddress = "e0:d5:5e:e4:bd:bf";
        };
        bridgeConfig.STP = false;
      };
      networks."05-enp4s0" = {
        matchConfig.Name = "enp4s0";
        networkConfig.Bridge = "br0";
        networkConfig.DHCP = "no";
        networkConfig.IPv6AcceptRA = "no";
        linkConfig.RequiredForOnline = "no";
      };
      networks."40-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = "192.168.8.101/24";
          Gateway = "192.168.8.1";
          DNS = "192.168.8.1";
        };
      };
    };

    virtualisation.containers.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;

    # boot.initrd.systemd.emergencyAccess = true;

    environment.systemPackages = with pkgs; [
      eslint
      obs-studio
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];

    users.users.sysadm.extraGroups = [ "libvirtd" ];
  };
}
