{ config, pkgs, lib, disko, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { rootfs = "/dev/nvme0n1"; homefs = "/dev/nvme1n1"; })

    ../../profiles/roles/workstation
    
    ../../profiles/software/python
    ../../profiles/software/steam    

  ];
  
  config = {
    networking = {
      hostName = "tartarus";
      dhcpcd = {
        enable = true;
        denyInterfaces = [ "enp3s0" "br0" ];
      };
    };

    systemd.network = {
      enable = true;
      netdevs."20-br0" = {
        netdevConfig = {
          Kind = "bridg";
          Name = "br0";
          MACAddress = "70:85:c2:b9:15:ed";          
        };
        bridgeConfig.STP = false;
      };
      networks."05-enp3s0" = {
        matchConfig.Name = "enp3s0";
        networkConfig.Bridge = "br0";
        networkConfig.DHCP = "no";
        networkConfig.IPv6AcceptRA = "no";
        linkConfig.RequiredForOnline = "no";
      };
      networks."40-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = "192.168.8.126/24";
          Gateway = "192.168.8.1";
          DNS = "192.168.8.1";
        };
      };
    };

    virtualisation.containers.enable = true;
    modules.virtualization.libvirt.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAA22ZIzJ7iz2Ue2tK3Qlzn5LIzLsPQL6x4rUewHIOG sysop@elysium"
    ];

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

    # boot.initrd.systemd.emergencyAccess = true;

    environment.systemPackages = with pkgs; [
      eslint
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];
  };
}

