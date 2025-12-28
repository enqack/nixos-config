{ pkgs, ... }:

{
  imports = [
    ../../../config/base/channel-init.nix
    ../../../config/base/config-fetch.nix
    ../../../config/base/env.nix
    ../../../config/base/networking.nix
    ../../../config/base/nix.nix
    ../../../config/base/users.nix

    ../../../config/filesystem/lvm.nix

    ../../../config/security/polkit.nix

    ../../../config/services/acpi.nix
    ../../../config/services/logind.nix
    #../../../config/services/nix-index.nix
    ../../../config/services/nixos-updates.nix
    ../../../config/services/ntp.nix
    ../../../config/services/ssh.nix
    ../../../config/services/sysstat.nix

    ../../../config/system/auto-upgrade.nix
    ../../../config/system/boot.nix
    ../../../config/system/garbage-collection.nix
    ../../../config/system/issue.nix
    ../../../config/system/time.nix

    ../../../config/ui/console.nix
    ../../../config/ui/fonts.nix

    ../../../modules/applications/tmux
    ../../../modules/applications/zsh

    ../../software/nix-extra
    ../../software/vim
  ];

  applications.tmux.enable = true;

  programs.dconf.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      init.defaultBranch = "main";
    };
  };

  # List packages installed in base profile.
  environment.systemPackages = with pkgs; [
    aspell
    age
    at
    atop
    bash
    bat
    btrfs-progs
    cachix
    chafa
    cmake
    cpio
    cryptsetup
    curl
    #devenv
    diceware
    dig
    direnv
    dnstop
    dosfstools
    ed
    entr
    e2fsprogs
    efibootmgr
    efitools
    efivar
    exfatprogs
    exif
    eza
    fastfetch
    ffmpeg-full
    fd
    ftop
    fuse2
    fzf
    fzf-git-sh
    gh
    git
    glow
    hdparm
    helix
    home-manager
    htop
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
    mpg123
    netcat
    nh
    ninja
    nmon
    noto-fonts
    noto-fonts-color-emoji
    openjdk
    parted
    pay-respects
    pciutils
    perl538Packages.FileMimeInfo
    pipx
    power-profiles-daemon
    psmisc
    python313
    python313Packages.dbus-python
    #python313Packages.jinja2
    python313Packages.notify2
    python313Packages.pip
    python313Packages.sphinx
    sphinx
    ssh-to-age
    sshfs
    stow
    systemctl-tui
    tcpdump
    tldr
    traceroute
    trash-cli
    tree
    unrar
    unzip
    usbutils
    wallust
    wget
    xdg-utils
    zip
    zoxide
  ];

  system.stateVersion = "24.11";
}
