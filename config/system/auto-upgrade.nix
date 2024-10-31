{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    operation = "switch";
  };
}

