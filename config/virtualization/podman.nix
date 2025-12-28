{ pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.containers.enable = true;

  environment.systemPackages = with pkgs; [
    dive
    podman-compose
    podman-tui
    python312Packages.podman
  ];    
}