{ config, lib, pkgs, ... }:
let
  cfg = config.modules.security.polkit;
in
{
  options.modules.security.polkit = {
    enable = lib.mkEnableOption "security polkit configuration";
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;
  };
}
