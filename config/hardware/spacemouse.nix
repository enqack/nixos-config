{ lib, pkgs, ... }:

{
  hardware.spacenavd.enable = true;

  environment.systemPackages = with pkgs; [
    spnavcfg
  ];
}

