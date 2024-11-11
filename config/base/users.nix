{ config, pkgs, ... }:

{
  users = {

    defaultUserShell = pkgs.zsh;

    groups = {
      sudo = {};
    };

    users.sysadm = {
      isNormalUser = true;
      description = "System Administrator";
      extraGroups = [ "wheel" ];
    };

    users.sysop = {
      isNormalUser = true;
      description = "System Operator";
      extraGroups = [ "sudo" ];
    };
  };

  security.sudo = {
    wheelNeedsPassword = false;
    extraRules = [
      # Allow execution of any command by all users in group sudo,
      # requiring a password.
      { groups = [ "sudo" ]; commands = [ "ALL" ]; }
    ];
  };
}

