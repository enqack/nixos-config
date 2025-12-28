{ pkgs, ... }:
let
  nixos-blur-theme = import ../../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  nixos-black-snowflake-plymouth = import ../../../pkgs/plymouth-themes/nixos-black-snowflake { pkgs = pkgs; };
  cptv = import ../../../pkgs/cptv { pkgs = pkgs; };
in
{
  imports = [
    # base profile
    ../base

    ../../../modules/hardware/graphics
    ../../../modules/hardware/bluetooth
    ../../../modules/hardware/sound
    
    ../../../modules/services/plymouth-config
    ../../../modules/services/xserver

    ../../../overlays/google-chrome
    ../../../overlays/vscode
  ];

  modules.hardware.graphics.enable = true;
  modules.hardware.bluetooth.enable = true;
  modules.hardware.sound.enable = true;
  modules.services.plymouth-config.enable = true;
  modules.services.xserver.enable = true;

  # List packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    alacritty
    alsa-utils
    ansi2html
    bluez
    calcurse
    cmatrix
    cptv
    firefox
    fuzzel
    gomatrix
    google-chrome
    gscreenshot
    kitty
    krita
    libsixel
    libxkbcommon
    liquidctl
    mesa
    #nemo
    nixos-bgrt-plymouth
    nixos-blur-theme
    nixos-black-snowflake-plymouth
    nixos-icons
    scrot
    slurp
    swayimg
    swaynotificationcenter
    swayosd
    vlc
    vscode
    wayland
    wayland-protocols
    wayland-utils
    wezterm
    wl-clipboard
    wofi
    xorg.setxkbmap
    xorg.xcursorthemes
    xwayland
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
