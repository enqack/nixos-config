{ config, pkgs, ... }:

{
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "altwin:menu_win";
  };
}

