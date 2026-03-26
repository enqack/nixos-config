{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.sound;
in
{
  options.modules.hardware.sound = {
    enable = lib.mkEnableOption "hardware sound configuration";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
