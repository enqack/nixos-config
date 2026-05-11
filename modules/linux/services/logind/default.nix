{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.logind;
in
{
  options.modules.services.logind = {
    enable = lib.mkEnableOption "services logind configuration";
  };

  config = lib.mkIf cfg.enable {
    services.logind = {
      settings.Login.HandlePowerKey = "ignore"; # Ignores a single press of the power button
    };
  };
}
