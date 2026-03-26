{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.ntp;
in
{
  options.modules.services.ntp = {
    enable = lib.mkEnableOption "services ntp configuration";
  };

  config = lib.mkIf cfg.enable {
    services.ntp.enable = true;
  };
}
