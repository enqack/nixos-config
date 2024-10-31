{ config, pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
  };
  
  systemd.services.openssh = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}

