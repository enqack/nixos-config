{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/base/channel-init
    ../../../modules/base/config-fetch
    ../../../modules/base/env
    ../../../modules/base/networking
    ../../../modules/base/nix
    ../../../modules/base/users
    ../../../modules/filesystem/lvm
    ../../../modules/security/polkit
    ../../../modules/services/acpi
    ../../../modules/services/logind
    ../../../modules/services/nix-index
    ../../../modules/services/nixos-updates
    ../../../modules/services/ntp
    ../../../modules/services/ssh
    ../../../modules/services/sysstat
    ../../../modules/system/auto-upgrade
    ../../../modules/system/boot
    ../../../modules/system/garbage-collection
    ../../../modules/system/issue
    ../../../modules/system/time
    ../../../modules/ui/console
    ../../../modules/ui/fonts

    ../../../modules/applications/tmux
    ../../../modules/applications/zsh

    ../../software/nix-extra
    ../../software/vim
  ];

  # Enable configruation modules
  modules.base.channel-init.enable = true;
  modules.base.config-fetch.enable = true;
  modules.base.env.enable = true;
  modules.base.networking.enable = true;
  modules.base.nix.enable = true;
  modules.base.users.enable = true;
  modules.filesystem.lvm.enable = true;
  modules.security.polkit.enable = true;
  modules.services.acpi.enable = true;
  modules.services.logind.enable = true;
  modules.services.nix-index.enable = true;
  modules.services.nixos-updates.enable = true;
  modules.services.ntp.enable = true;
  modules.services.ssh.enable = true;
  modules.services.sysstat.enable = true;
  modules.system.auto-upgrade.enable = true;
  modules.system.boot.enable = true;
  modules.system.garbage-collection.enable = true;
  modules.system.issue.enable = true;
  modules.system.time.enable = true;
  modules.ui.console.enable = true;
  modules.ui.fonts.enable = true;

  # Enable application modules
  modules.applications.tmux.enable = true;

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
