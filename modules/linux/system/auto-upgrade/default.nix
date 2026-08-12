{ config, lib, pkgs, ... }:

let
  cfg = config.modules.system.auto-upgrade;
in
{
  options.modules.system.auto-upgrade = {
    enable = lib.mkEnableOption "system auto-upgrade configuration";

    flake = lib.mkOption {
      type = lib.types.str;
      description = "The remote flake URI (URL) to use for auto-upgrades.";
      example = "github:user/repo";
    };

    dates = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
      description = "How often or when to run the auto-upgrade. Accepts systemd calendar format.";
      example = "04:00";
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      allowReboot = false;
      
      dates = cfg.dates;
      flake = cfg.flake;
      
      flags = [
        "--commit-lock-file"
      ];
      
      randomizedDelaySec = "45min";
    };
  };
}

