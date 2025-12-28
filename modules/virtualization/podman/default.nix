{ config, lib, pkgs, ... }:
let
  cfg = config.modules.virtualization.podman;
in
{
  options.modules.virtualization.podman = {
    enable = lib.mkEnableOption "virtualization podman configuration";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
