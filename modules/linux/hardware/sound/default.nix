{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.sound;
  btEnabled = config.modules.hardware.bluetooth.enable or false;
in
{
  options.modules.hardware.sound = {
    enable = lib.mkEnableOption "hardware sound configuration";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      systemd.services.pipewire = {
        enable = lib.mkForce true;
        restartIfChanged = true;
        serviceConfig = {
          Restart = "always";
          RestartSec = 5;
        };
      };
    }

    (lib.mkIf btEnabled {
      services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.codecs" = "[ sbc sbc_xq aac ldac aptx aptx_hd ]";
          "bluez5.autoswitch-to-headset-profile" = false;
        };
      };
    })
  ]);
}

