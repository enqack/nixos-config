{ config, pkgs, ... }:

{
  imports = [
    #../../../../modules/linux/base/channel-init
    ../../../../modules/darwin/base/nix
    #../../../../modules/linux/base/users
    ../../../../modules/darwin/services/nix-index
    #../../../../modules/linux/services/ssh
    ../../../../modules/shared/system/issue
    ../../../../modules/darwin/ui/fonts

    #../../../../modules/linux/applications/tmux
    ../../../../modules/darwin/applications/zsh

    ../../../shared/software/nix-extra
    ../../../shared/software/vim
  ];

  # Enable configruation modules
  #modules.base.channel-init.enable = true;
  modules.base.nix.enable = true;
  #modules.base.users.enable = true;
  modules.services.nix-index.enable = true;
  #modules.services.ssh.enable = true;
  modules.system.issue.enable = true;
  modules.ui.fonts.enable = true;

  # Enable application modules
  #modules.applications.tmux.enable = true;

  # programs.git = {
  #   enable = true;
  #   lfs.enable = true;
  #   config = {
  #     init.defaultBranch = "main";
  #   };
  # };

  # List packages installed in base profile.
  environment.systemPackages = with pkgs; [
    aspell
    age
    bash
    bat
    cachix
    chafa
    cmake
    cpio
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
    exif
    eza
    fastfetch
    ffmpeg-full
    fd
    fuse2
    fzf
    fzf-git-sh
    gh
    git
    glow
    helix
    home-manager
    htop
    iftop
    jq
    killall
    lf
    libnotify
    logrotate
    lsof
    mc
    meson
    mpg123
    netcat
    nh
    ninja
    noto-fonts
    noto-fonts-color-emoji
    openjdk
    pay-respects
    pciutils
    perl538Packages.FileMimeInfo
    pipx
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
    tig
    tldr
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

  system.stateVersion = 6;
}
