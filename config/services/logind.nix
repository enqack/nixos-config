{ config, pkgs, ... }:

{
  services.logind = {
    powerKey = "ignore"; # Ignores a single press of the power button
  };
}

