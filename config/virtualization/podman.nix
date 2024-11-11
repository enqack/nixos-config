{ config, pkgs, ... }:

{
  virtualisation.podman.enable = true;

  virtualisation.containers.enable = true;

  environment.systemPackages = with pkgs; [
    podman-tui
    python312Packages.podman
  ];    
}