{ config, pkgs, lib, disko, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { rootfs = "/dev/nvme0n1"; homefs = "/dev/nvme1n1"; })

    ../../profiles/roles/workstation

    ../../profiles/software/python
    ../../profiles/software/steam

    ../../modules/hardware/spacemouse
  ];

  modules.hardware.spacemouse.enable = true;

  config = {
    networking = {
      hostName = "catalyst";
      firewall = {
        allowedTCPPorts = [ 5000 ];
        allowedUDPPorts = [ 65458 ];
        allowedUDPPortRanges = [
          { from = 23235; to = 23262; }
          { from = 23243; to = 23253; }
        ];
      };
    };

    virtualisation.containers.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

    boot.loader.grub = {
      theme = pkgs.stdenv.mkDerivation {
        pname = "distro-grub-themes";
        version = "3.1";
        src = pkgs.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "v3.1";
          hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        };
        installPhase = "cp -r customize/nixos $out";
      };
    };

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

    # boot.initrd.systemd.emergencyAccess = true;

    environment.systemPackages = with pkgs; [
      inputs.spnav-mouse.packages.${config.nixpkgs.system}.spnav-mouse
      eslint
      obs-studio
      wineWowPackages.stable # support both 32-bit and 64-bit applications
    ];
  };
}
