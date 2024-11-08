{ config, pkgs, ... }:

{
  users.groups.sudo = {};  # Group for passworded sudo access

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraRules = [
      {
        groups = [ "sudo" ];     # Group for passworded sudo
        commands = [ { command = "ALL"; options = []; } ];  # prompts for password
      }
    ];
  };
}
