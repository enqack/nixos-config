{ config, pkgs, ... }:
let
  channel-url = "https://nixos.org/channels/nixos-${config.system.stateVersion}";
  channel-name = "nixpkgs";
in
{
  # Define an activation script to run once per machine
  system.activationScripts.channelInit = {
    text = ''
      # Check if the system is already configured
      if [ -f /etc/nixos/.channel-initialized ]; then
        echo "Nix Channel already initialized."
        exit 0
      fi

      echo "Initializing nix channel. Adding: ${channel-url} to ${channel-name}"
      ${pkgs.nix}/bin/nix-channel --add ${channel-url} ${channel-name}
      ${pkgs.nix}/bin/nix-channel --update

      # Mark as configured
      touch /etc/nixos/.channel-initialized
    '';
  };    
}