{ config, pkgs, ... }:
let
  nixosBlurTheme = import ../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  cptv = import ../../pkgs/cptv { pkgs = pkgs; };
in
{
  imports = [
    ../../modules/applications/zsh
    ../../overlays/google-chrome
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    alacritty
    alsa-utils
    aspell
    at
    atop
    bash
    bat
    blueman
    bluez
    calcurse
    cptv
    curl
    devenv
    dnstop
    ed
    entr
    exfatprogs
    exif
    firefox
    ftop
    fuzzel
    fuse2
    fzf
    git
    google-chrome
    gscreenshot
    home-manager
    hyprpanel
    iftop
    iotop
    jq
    killall
    krita
    lf
    libinput
    libnotify
    libva
    libxkbcommon
    liquidctl
    logrotate
    lm_sensors
    lsof
    mc
    mesa
    nemo
    netcat
    nix-prefetch-git
    nixos-bgrt-plymouth
    nixosBlurTheme
    nmon
    openjdk
    pciutils
    pipx
    power-profiles-daemon
    python312
    python312Packages.pip
    scrot
    slurp
    sshfs
    stow
    swayimg
    swaynotificationcenter
    swayosd
    sysstat
    tcpdump
    tmux
    traceroute
    trash-cli
    tree
    unrar
    unzip
    vim
    vlc
    vscode
    wayland
    wayland-protocols
    wget
    wl-clipboard
    wofi
    xorg.xcursorthemes
    xwayland
    zip
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
