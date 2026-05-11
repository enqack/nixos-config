{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.nixos-updates;
  scriptFile = pkgs.writeText "nixos-updates"
  ''
    #!/usr/bin/env bash

    set -euo pipefail

    # Create a temporary directory
    tempdir=$(mktemp -d /tmp/tmp.nixos-updatesinfo.XXX)

    # Copy the repository to temporary directory
    cp -Lr /etc/nixos/. $tempdir/.
    cd $tempdir

    # Update the `nixpkgs` input if `flake.lock` is older than 7 days
    if [ -f /etc/nixos/flake.lock ] && find /etc/nixos/flake.lock -mtime +7 | grep -q .; then
        nix flake lock --update-input nixpkgs
    fi

    # Build the system configuration
    nix build ".#nixosConfigurations.$(hostname).config.system.build.toplevel"

    # Check and store differences
    update_output=$(nix store diff-closures /run/current-system ./result       | awk '/[0-9] →|→ [0-9]/ && !/nixos/')

    if [[ -z "$update_output" ]]; then
        echo "No updates available."
    else
        echo "$update_output"
    fi

    # Cleanup
    cd ~-
    rm -rf "$tempdir"
  '';
in
{ 
  options.modules.services.nixos-updates = {
    enable = lib.mkEnableOption "services nixos-updates configuration";
  };

  config = lib.mkIf cfg.enable {
    systemd.services."nixos-updates" = {
      description = "Update nix-updates cache";
      wants = [ "nixos-updates.timer" ];

      path = [ pkgs.git pkgs.nix pkgs.hostname pkgs.findutils pkgs.gawk ];

      serviceConfig = {
        User = "root";
        Group = "users";
        StateDirectory = "nixos";
        StateDirectoryMode = "0750";
        StandardOutput = "file:%S/nixos/nixos-updates.txt";
        StandardError = "file:/dev/null";
        ExecStart = ''
          ${pkgs.bash}/bin/bash ${scriptFile}
        '';      
      };
    };

    systemd.timers."nixos-updates" = {
      description = "Run nixos-updates update hourly";
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
