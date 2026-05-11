{ config, lib, pkgs, ... }:
let
  cfg = config.modules.ui.fonts;
in
{
  options.modules.ui.fonts = {
    enable = lib.mkEnableOption "ui fonts configuration";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        corefonts
        ipafont
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-mono
        nerd-fonts.noto
        nerd-fonts.symbols-only
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
          monospace = [ "FiraMono Nerd Font" "Symbols Nert Font" "Noto Sans Mono CJK JP" ];
          sansSerif = [ "NotoSans Nerd Font" "Symbols Nerd Font" "Noto Sans CJK JP" ];
          serif = [ "NotoSerif Nerd Font" "Noto Serif CJK JP"];
        };
      };
    };
  };
}
