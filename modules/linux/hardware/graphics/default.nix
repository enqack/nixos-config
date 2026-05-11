{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.graphics;
in
{
  options.modules.hardware.graphics = {
    enable = lib.mkEnableOption "hardware graphics configuration";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-vaapi-driver libvdpau-va-gl ];
    };
  };
}
