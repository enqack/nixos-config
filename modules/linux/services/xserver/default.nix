{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.xserver;
in
{
  options.modules.services.xserver = {
    enable = lib.mkEnableOption "services xserver configuration";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "altwin:menu_win";
    };
  };
}
