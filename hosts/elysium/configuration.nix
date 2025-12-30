{ config, pkgs, lib, disko, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { rootfs = "/dev/nvme0n1"; homefs = "/dev/nvme1n1"; })

    ../../profiles/roles/workstation
    
    ../../profiles/software/python
    ../../profiles/software/steam
    ../../profiles/software/dms-greeter


    ../../modules/hardware/spacemouse
  ];
  
  config = {
    networking = {
      hostName = "elysium";
      dhcpcd = {
        enable = true;
        denyInterfaces = [ "enp113s0" "br0" ];
      };
    };

    systemd.network = {
      enable = true;
      netdevs."20-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
          MACAddress = "bc:fc:e7:75:28:64";
        };
        bridgeConfig.STP = false;
      };
      networks."05-enp113s0" = {
        matchConfig.Name = "enp113s0";
        networkConfig.Bridge = "br0";
        networkConfig.DHCP = "no";
        networkConfig.IPv6AcceptRA = "no";
        linkConfig.RequiredForOnline = "no";
      };
      networks."40-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = "192.168.8.100/24";
          Gateway = "192.168.8.1";
          DNS = "192.168.8.1";
        };
      };
    };

    modules.hardware.spacemouse.enable = true;
    modules.system.boot.grubGfxMode = "3440x1440,2560x1440,1920x1080,auto";

    distro-grub-themes = {
      enable = true;
    };

    virtualisation.containers.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

    services.udev.extraRules = ''
      ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c638", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      SUBSYSTEM=="input", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c638", TAG+="systemd", ENV{SYSTEMD_WANTS}="spnav-mouse.service"
    '';

    systemd.services.spnav-mouse = {
      enable = true;
      #wantedBy = [ "default.target" ];
      description = "SpaceMouse to mouse control bridge using spacenavd.";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${inputs.spnav-mouse.packages.x86_64-linux.spnav-mouse}/bin/spnav-mouse
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      inputs.spnav-mouse.packages.${config.nixpkgs.system}.spnav-mouse
      obs-studio
      streamdeck-ui
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];
  };
}

