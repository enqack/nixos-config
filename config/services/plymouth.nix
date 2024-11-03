{ config, pkgs, lib, ... }:

let
  nixos-blur-theme = import ../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  nixos-black-snowflake-plymouth = import ../../pkgs/plymouth-themes/nixos-black-snowflake { pkgs = pkgs; };
in
{
  imports = [ ../../modules/services/plymouth ];

  services.plymouth = {
    enable = false;
    theme = "nixos-bgrt";
    grubTimeout = 3;
  };
  boot.plymouth.themePackages = [ nixos-blur-theme nixos-black-snowflake-plymouth pkgs.nixos-bgrt-plymouth ];
}

