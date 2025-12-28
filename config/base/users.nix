{ pkgs, ... }:
let
  rootPassword = builtins.hashString "sha256" "none";
in
{
  users = {

    defaultUserShell = pkgs.zsh;

    groups = {
      sudo = {};
    };

    users.root = {
      initialPassword = rootPassword;
    };

    users.sysadm = {
      isNormalUser = true;
      description = "System Administrator";
      extraGroups = [ "wheel" "dialout" "libvirtd"];
      initialPassword = "sysadm";
    };

    users.sysop = {
      isNormalUser = true;
      description = "System Operator";
      extraGroups = [ "sudo" "dialout" "libvirtd" ];
      initialPassword = "sysop";
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

