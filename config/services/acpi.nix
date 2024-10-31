{ config, pkgs, ... }:

{
  services.acpid.enable = true;
  services.upower.enable = true;
}

