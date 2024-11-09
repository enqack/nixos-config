{ config, pkgs, ... }:

{
  virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    podman-tui
    python312Packages.podman
  ];    
}