{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/applications/zsh

    ../../../config/base/env.nix
    ../../../config/base/nix.nix
    ../../../config/base/networking.nix
    ../../../config/base/users.nix

    ../../../config/services/acpi.nix
    ../../../config/services/logind.nix
    ../../../config/services/nix-index.nix
    ../../../config/services/ssh.nix

    ../../../config/system/auto-upgrade.nix
    ../../../config/system/boot.nix
    ../../../config/system/garbage-collection.nix
    ../../../config/system/issue.nix
    ../../../config/system/time.nix

    ../../../config/filesystem/lvm.nix

    ../../../config/ui/console.nix
    ../../../config/ui/fonts.nix
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    aspell
    at
    atop
    bash
    bat
    chafa
    cmake
    cpio
    curl
    devenv
    dnstop
    ed
    entr
    exfatprogs
    exif
    fastfetch
    ftop
    fuse2
    fzf
    git
    home-manager
    iftop
    iotop
    jq
    killall
    lf
    libinput
    libnotify
    libva
    logrotate
    lm_sensors
    lsof
    mc
    meson
    netcat
    ninja
    nix-index
    nix-prefetch-git
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
    sshfs
    stow
    sysstat
    tcpdump
    tmux
    traceroute
    trash-cli
    tree
    unrar
    unzip
    vim
    wget
    zip
  ];
}
