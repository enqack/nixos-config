{ config, pkgs, ... }:

{
  users = {

    defaultUserShell = pkgs.zsh;

    users.sysop = {
      isNormalUser = true;
      description = "sysop";
      extraGroups = [ "audio" "networkmanager" "wheel" ];
    };

    users.enqack = {
      isNormalUser = true;
      description = "enqack";
      extraGroups = [ "audio" "networkmanager" "wheel" ];
    };

  };
}

