{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = lib.mkEnableOption "hardware bluetooth configuration";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          ControllerMode = "dual";
          Experimental = true; # Exposes battery levels for supported devices
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    systemd.services.bluetooth = {
      enable = true;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

    environment.systemPackages = with pkgs; [
      bluetui
      bluez-tools
      playerctl
      libnotify
    ];
  };
}

