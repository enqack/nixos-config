{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl ];
  };
}

