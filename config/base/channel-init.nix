{ config, pkgs, ... }:

{
  # Define an activation script to run once per machine
  system.activationScripts.channelInit = {
    text = ''
      nix-channel --add https://nixos.org/channels/nixos-${system.stateVersion}} nixpkgs
    '';
  };    
}