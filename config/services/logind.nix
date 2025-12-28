{ config, pkgs, ... }:

{
  services.logind = {
    settings.Login.HandlePowerKey = "ignore"; # Ignores a single press of the power button
  };
}

