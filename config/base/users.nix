{ config, pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;

    users.sysop = {
      isNormalUser = true;
      description = "sysop";
      extraGroups = [ "audio" "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };
  };
}

