{ config, pkgs, ... }:
let
  channel-url = "https://nixos.org/channels/nixos-${config.system.stateVersion}";
  channel-name = "nixpkgs";
in
{
  # Define an activation script to run once per machine
  system.activationScripts.channelInit = {
    text = ''
      echo "Initializing nix channel. Adding: ${channel-url} to ${channel-name}"
      ${pkgs.nix}/bin/nix-channel --add ${channel-url} ${channel-name}
    '';
  };    
}