{ config, lib, pkgs, ... }:
let
  cfg = config.modules.system.auto-upgrade;
in
{
  options.modules.system.auto-upgrade = {
    enable = lib.mkEnableOption "system auto-upgrade configuration";
  };

  config = lib.mkIf cfg.enable {
    # System auto upgrade
    system.autoUpgrade = {
      enable = true;
      allowReboot = false;
      dates = "daily";
      flake = "github:enqack/nixos-config#catalyst";
      flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    };
  };
}
