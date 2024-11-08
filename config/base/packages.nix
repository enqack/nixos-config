{ config, pkgs, ... }:
let
  nixos-blur-theme = import ../../pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  nixos-black-snowflake-plymouth = import ../../pkgs/plymouth-themes/nixos-black-snowflake { pkgs = pkgs; };
  cptv = import ../../pkgs/cptv { pkgs = pkgs; };
in
{
  imports = [
    ../../modules/applications/zsh
    ../../overlays/google-chrome
    ../../overlays/vscode
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
    chafa
    cmake
    cmatrix
    cpio
    cptv
    curl
    devenv
    dnstop
    ed
    entr
    exfatprogs
    exif
    fastfetch
    firefox
    ftop
    fuzzel
    fuse2
    fzf
    git
    gomatrix
    google-chrome
    gscreenshot
    home-manager
    iftop
    iotop
    jq
    killall
    kitty
    krita
    lf
    libinput
    libnotify
    libsixel
    libva
    libxkbcommon
    liquidctl
    logrotate
    lm_sensors
    lsof
    mc
    mesa
    meson
    nemo
    netcat
    ninja
    nix-index
    nix-prefetch-git
    nixos-bgrt-plymouth
    nixos-blur-theme
    nixos-black-snowflake-plymouth
    nixos-icons
    nmon
    openjdk
    pciutils
    perl538Packages.FileMimeInfo
    pipx
    power-profiles-daemon
    python312
    python312Packages.dbus-python
    python312Packages.notify2
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
    wezterm
    wget
    wl-clipboard
    wofi
    xorg.setxkbmap
    xorg.xcursorthemes
    xwayland
    zip
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
