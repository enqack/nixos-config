{ config, pkgs, lib, ... }:
let
  nixosBlurTheme = import ./pkgs/plymouth-themes/nixos-blur { pkgs = pkgs; };
  cptv = import ./pkgs/cptv { pkgs = pkgs; };
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./overlays/google-chrome
      ./modules/plymouth
    ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
      ];
    };
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  system.autoUpgrade.operation = "switch";

  nix.gc.automatic = true;
  nix.gc.dates = "daily"; # Options: "daily", "weekly"
  nix.gc.options = "--delete-older-than 90d --delete-generations +25 --max-freed 256*1240*1024 --log-format bar-with-logs"; 

  # Bootloader
  boot.loader = {
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    # grub.splashImage = "/home/sysop/nix-bootloader.png";
    efi.canTouchEfiVariables = true;
    # efi.efiSysMountPoint = "/boot/EFI";
  };
 
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.plymouth = {
    enable = true; 
    theme = "nixos-blur";
    grubTimeout = 3;
  };
  boot.plymouth.themePackages = [ nixosBlurTheme pkgs.nixos-bgrt-plymouth ];

  networking.hostName = "flex";

  # Enable networking
  networking.networkmanager.enable = true;

  # Setup console
  console = {
    earlySetup = true;
    font = "ter-v32n";
    useXkbConfig = true;
    packages = with pkgs; [ terminus_font ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8"; 
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts = {
    packages = with pkgs; [
      nerdfonts
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "slight";
      subpixel.rgba = "rgb";
      subpixel.lcdfilter = "default";
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "NotoSans Nerd Font" ];
        serif = [ "NotoSerif Nerd Font" ];
      };
    };
  };

  services.acpid.enable = true;
  services.upower.enable = true;

  # Define user settings
  users.defaultUserShell = pkgs.zsh;

  # Define a user account.
  users.users.sysop = {
    isNormalUser = true;
    description = "sysop";
    extraGroups = [ "audio" "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    promptInit = builtins.readFile ./modules/zsh/global-zsh-config.zsh;
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      lt = "ls -ltr";
      l  = "ls -CF";

      edit-system = "sudo vim /etc/nixos/configuration.nix";
      edit-home   = "vim ~/.config/nixos/home.nix";
      rebuild-system = "sudo nixos-rebuild switch --flake /etc/nixos#flex";
      rebuild-home   = "nix run home-manager/master -- switch --flake ~/.config/nixos";
    };
  };

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Configuring OpenSSH to restart on failure
  systemd.services.openssh = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";  # Restart only on failure
      RestartSec = 3;
    };
  };

  # Enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Configuring Pipewire to restart on failure
  systemd.services.pipewire = {
    enable = lib.mkForce true;
    restartIfChanged = true; # Restart on configuration changes
    # Correctly specify restart options here
    serviceConfig = {
      Restart = "always";       # Restart the service if it fails
      RestartSec = 5;           # Wait 5 seconds before restarting
    };
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
  # Configuring Bluetooth to restart on failure
  systemd.services.bluetooth = {
    enable = true;
    # Correctly specify restart options here
    serviceConfig = {
      Restart = "on-failure";   # Restart only on failure
      RestartSec = 3;           # Wait 3 seconds before restarting
    };
  }; 
  services.blueman.enable = true;

  # Environment
  environment.shells = with pkgs; [ zsh bash ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [ 
      "${XDG_BIN_HOME}"
      "${pkgs.coreutils}/bin"
    ];
  };

  environment.etc."zshenv.local".text = builtins.readFile ./modules/zsh/global-zsh-env.zsh;
  
  environment.etc."zprofile.local".text = builtins.readFile ./modules/zsh/global-zsh-profile.zsh;
  

  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };

  # This value determines the NixOS release version.
  system.stateVersion = "24.05";
}

