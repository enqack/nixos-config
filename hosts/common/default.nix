{ lib, config, outputs, pkgs, ... }:
  with lib;
{
  imports = [
    ./nix.nix
    ./locale.nix
    ../../users
  ] ++ (builtins.attrValues outputs.nixosModules);

  boot = {
    initrd = {
      compressor = mkDefault "zstd";
      compressorArgs = mkDefault ["-19"];

      systemd = {
        strip = mkDefault true;                         # Saves considerable space in initrd
      };
    };
    kernel.sysctl = {
      "vm.dirty_ratio" = mkDefault 6;                   # sync disk when buffer reach 6% of memory
    };
    kernelPackages = pkgs.linuxPackages_latest;         # Latest kernel
  };

  console = {
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal ];
  xdg.portal.config.common.default = "*";

  host = {
    application = {
      bat.enable = mkDefault true;
      bind.enable = mkDefault false;
      binutils.enable = mkDefault true;
      coreutils.enable = mkDefault true;
      curl.enable = mkDefault true;
      dhcpcd.enable = mkDefault true;
      dust.enable = mkDefault true;
      e2fsprogs.enable = mkDefault true;
      fzf.enable = mkDefault true;
      git.enable = mkDefault true;
      glow.enable = mkDefault true;
      gpm.enable = mkDefault true;
      htop.enable = mkDefault true;
      iftop.enable = mkDefault true;
      less.enable = mkDefault true;
      lsof.enable = mkDefault true;
      pciutils.enable = mkDefault true; 
      rsync.enable = mkDefault true;
      tmux.enable = mkDefault true;
      tree.enable = mkDefault true;
      vim.enable = mkDefault true;
      wget.enable = mkDefault true;
      zsh.enable = mkDefault true;
    };
    user = {
      sysop.enable = mkDefault true;
    };
    feature = {
      home-manager.enable = mkDefault true;
    };
    network = {
      # domainname = mkDefault "local";
      wired.enable = mkDefault true;
      wired.type = mkDefault "dynamic";
    };
    service = {
      logrotate.enable = mkDefault true;
      ssh = {
        enable = mkDefault true;
        harden = mkForce false;
      };
    };
  };
  
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  environment.sessionVariables = {
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
  services.openssh.settings.PermitRootLogin = "yes";

  users.defaultUserShell = pkgs.zsh;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
