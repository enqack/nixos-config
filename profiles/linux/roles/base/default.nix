{ config, pkgs, ... }:

{
  imports = [
    ../../../../modules/linux/base/channel-init
    ../../../../modules/linux/base/config-fetch
    ../../../../modules/linux/base/env
    ../../../../modules/linux/base/networking
    ../../../../modules/linux/base/nix
    ../../../../modules/linux/base/users
    ../../../../modules/linux/filesystem/lvm
    ../../../../modules/linux/security/polkit
    ../../../../modules/linux/services/acpi
    ../../../../modules/linux/services/logind
    ../../../../modules/linux/services/nix-index
    ../../../../modules/linux/services/nixos-updates
    ../../../../modules/linux/services/ntp
    ../../../../modules/linux/services/ssh
    ../../../../modules/linux/services/sysstat
    ../../../../modules/linux/system/auto-upgrade
    ../../../../modules/linux/system/boot
    ../../../../modules/linux/system/garbage-collection
    ../../../../modules/shared/system/issue
    ../../../../modules/linux/system/time
    ../../../../modules/linux/ui/console
    ../../../../modules/linux/ui/fonts

    ../../../../modules/linux/applications/tmux
    ../../../../modules/linux/applications/zsh

    ../../../shared/software/nix-extra
    ../../../shared/software/vim
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

  environment.shells = with pkgs; [ nushell ];

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
    duf
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
    nushell
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
    tig
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
