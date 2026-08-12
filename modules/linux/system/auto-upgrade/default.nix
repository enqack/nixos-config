{ config, lib, pkgs, ... }:

let
  cfg = config.modules.system.auto-upgrade;
in
{
  options.modules.system.auto-upgrade = {
    enable = lib.mkEnableOption "system auto-upgrade configuration";

    flake = lib.mkOption {
      # Allow either a string (URL) or a path (local file location)
      type = with lib.types; either str path;
      default = "/etc/nixos";
      description = "The flake URI (URL) or local file path to use for auto-upgrades.";
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

      flake = toString cfg.flake;
      
      flags = [ 
        "--update-input" 
        "nixpkgs" 
        "--commit-lock-file" 
      ];
      
      randomizedDelaySec = "45min";
    };
  };
}
