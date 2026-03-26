{ config, pkgs, lib, ... }:

let
  cfg = config.modules.services.plymouth-config;
  nixos-blur-theme = import ../../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  nixos-black-snowflake-plymouth = import ../../../pkgs/plymouth-themes/nixos-black-snowflake { pkgs = pkgs; };
in
{
  options.modules.services.plymouth-config = {
    enable = lib.mkEnableOption "services plymouth configuration";
  };

  imports = [ ../plymouth ];

  config = lib.mkIf cfg.enable {
    services.plymouth = {
      enable = false;
      theme = "nixos-bgrt";
      grubTimeout = 3;
    };
    boot.plymouth.themePackages = [ nixos-blur-theme nixos-black-snowflake-plymouth pkgs.nixos-bgrt-plymouth ];
  };
}
