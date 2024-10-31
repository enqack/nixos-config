{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerdfonts
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "slight";
      subpixel.rgba = "rgb";
      subpixel.lcdfilter = "default";
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "NotoSans Nerd Font" ];
        serif = [ "NotoSerif Nerd Font" ];
      };
    };
  };
}
