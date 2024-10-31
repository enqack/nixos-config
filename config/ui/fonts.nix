{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      corefonts
      ipafont
      nerdfonts
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
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
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
        sansSerif = [ "NotoSans Nerd Font" "Noto Sans CJK JP" ];
        serif = [ "NotoSerif Nerd Font" "Noto Serif CJK JP"];
      };
    };
  };
}
