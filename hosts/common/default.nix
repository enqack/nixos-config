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
      curl.enable = mkDefault true;
      dhcpcd.enable = mkDefault true;
      git.enable = mkDefault true;
      glow.enable = mkDefault true;
      gpm.enable = mkDefault true;
      htop.enable = mkDefault true;
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
      wired.enable = mkDefault true;
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

  #TODO Disable dangerous ssh setting
  services.openssh.settings.PermitRootLogin = "yes";

  users.defaultUserShell = pkgs.zsh;
}
