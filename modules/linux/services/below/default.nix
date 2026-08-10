{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.below;
in
{
  options.modules.services.below = {
    enable = lib.mkEnableOption "services below configuration";
  };

  config = lib.mkIf cfg.enable {
    services.below = {
      enable = true;
      compression.enable = true;
    };
  };
}
