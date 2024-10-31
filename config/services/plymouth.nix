{ config, pkgs, lib, ... }:

let
  nixosBlurTheme = import ../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
in
{
  imports = [ ../../modules/services/plymouth ];

  services.plymouth = {
    enable = true;
    theme = "nixos-blur";
    grubTimeout = 3;
  };
  boot.plymouth.themePackages = [ nixosBlurTheme pkgs.nixos-bgrt-plymouth ];
}

