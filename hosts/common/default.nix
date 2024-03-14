{ lib, config, outputs, pkgs, ... }:
  with lib;
{
  imports = [
    ./nix.nix
    ./locale.nix
    ../../users
  ] ++ (builtins.attrValues outputs.nixosModules);

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
    service = {
      logrotate.enable = mkDefault true;
      ssh = {
        enable = mkDefault true;
        harden = mkDefault false;
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  users.defaultUserShell = pkgs.zsh;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
