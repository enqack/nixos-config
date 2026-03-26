{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.spacemouse;
in
{
  options.modules.hardware.spacemouse = {
    enable = lib.mkEnableOption "hardware spacemouse configuration";
  };

  config = lib.mkIf cfg.enable {
    hardware.spacenavd.enable = true;

    environment.systemPackages = with pkgs; [
      spnavcfg
    ];
  };
}
