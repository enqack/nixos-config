{ config, lib, pkgs, ... }:
let
  cfg = config.modules.ui.fonts;
in
{
  options.modules.ui.fonts = {
    enable = lib.mkEnableOption "darwin ui fonts configuration";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
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
  };
}
