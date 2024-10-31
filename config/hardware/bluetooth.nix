{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
  systemd.services.bluetooth = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}

