{ config, pkgs, lib, ... }:

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

