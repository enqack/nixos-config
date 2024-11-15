{ config, pkgs, ... }:
let
  nixos-blur-theme = import ../../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  nixos-black-snowflake-plymouth = import ../../../pkgs/plymouth-themes/nixos-black-snowflake { pkgs = pkgs; };
  cptv = import ../../../pkgs/cptv { pkgs = pkgs; };
in
{
  imports = [
    # base profile
    ../base

    ../../../config/hardware/graphics.nix
    ../../../config/hardware/bluetooth.nix
    ../../../config/hardware/sound.nix
    
    ../../../config/services/plymouth.nix
    ../../../config/services/xserver.nix

    ../../../overlays/google-chrome
    ../../../overlays/vscode
  ];

  # List packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    alacritty
    alsa-utils
    blueman
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
    nemo
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
