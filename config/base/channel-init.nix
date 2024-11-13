{ config, pkgs, ... }:

{
  # Define an activation script to run once per machine
  system.activationScripts.channelInit = {
    text = ''
      ${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/nixos-${config.system.stateVersion}} nixpkgs
    '';
  };    
}