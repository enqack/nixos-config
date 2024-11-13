{ config, pkgs, ... }:
let
    config-repo = "https://github.com/enqack/nixos-config.git";
    config-user = "sysadm";
in
{
  # Define an activation script to run once per machine
  system.activationScripts.configFetch = {
    text = ''
      # Check if the system is already configured
      if [ -f /etc/nixos/.config-fetched ]; then
        echo "System configuration already fetched."
        exit 0
      fi

      # Check if NixOS configuration exists
      if [ ! -d /etc/nixos ] || [ -z "$(ls -A /etc/nixos)" ]; then
        ${pkgs.git}/bin/git clone ${config-repo} /home/${config-user}/.config/nixos || true
        ${pkgs.coreutils}/bin/ln -s /home/${config-user}/.config/nixos /etc/nixos || ture
      fi

      # Mark as configured
      touch /etc/nixos/.config-fetched
      echo "System configuration downloaded and marked as complete. Please run nixos-rebuild manually."
    '';
  };
}
