{ lib, config, outputs, pkgs, ... }:

{
  imports = (builtins.attrValues outputs.nixosModules);

  boot = {
    kernelParams = [ "nohibernate" ];
    tmp.cleanOnBoot = true;
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  nix = {
    settings = {
      warn-dirty = false;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Set your time zone.
  time.timeZone = "UTC";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_DK.utf8";
  };

  console = {
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal ];
  xdg.portal.config.common.default = "*";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    curl
    dhcpcd
    git
    glow
    gpm
    htop
    tmux
    tree
    vim
    wget
  ];

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #host = {
  #  application = {
  #    rsync.enable = lib.mkDefault true;
  #  };
  #};

    programs.zsh = {
      enable = true;
      enableLsColors = true;
      enableCompletion = true;
      enableGlobalCompInit = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -alF";
        la = "ls -A";
        lt = "ls -ltr";
        l  = "ls -CF";

        df = "df -h";
        free = "free -h";
      };

      histSize = 100000;
      histFile = "~/.config/zsh/history";
    };

    environment.etc = {
      "zshenv.local" = { source = ../../modules/application/zsh/files/zshenv.local; };
      "zshrc.local" = { source = ../../modules/application/zsh/files/zshrc.local; };
    };

  environment.sessionVariables = rec {
    # Enable scrolling in git diff
    DELTA_PAGER = "less -R";
  };

  # System-wide environment variables
  environment.variables = {
    EDITOR = "vim";
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’..
  users.users.sysop = {
    isNormalUser = true;
    description = "sysop";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
