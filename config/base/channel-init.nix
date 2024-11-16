{ config, pkgs, ... }:

let
  channelUrl = "https://nixos.org/channels/nixos-${config.system.stateVersion}";
  channelName = "nixpkgs";
  flagFile = "/var/lib/nixos-channel-initialized";
  logFile = "/var/log/channel-init.log";

  channelInitScript = ''
    set -e  # Stop on errors

    # Check if the channel is already initialized
    if [ -f ${flagFile} ]; then
      echo "Nix Channel already initialized." | tee -a ${logFile}
      exit 0
    fi

    echo "Initializing Nix channel. Adding: ${channelUrl} to ${channelName}" | tee -a ${logFile}
    ${pkgs.nix}/bin/nix-channel --add ${channelUrl} ${channelName}
    ${pkgs.nix}/bin/nix-channel --update

    # Create flag directory if it doesn't exist
    ${pkgs.coreutils}/bin/mkdir -p $(dirname ${flagFile})

    # Mark as configured
    ${pkgs.coreutils}/bin/touch ${flagFile}
    echo "Nix channel initialization completed at $(date)" | tee -a ${logFile}
  '';
in
{
  systemd.services.channel-init = {
    description = "Initialize Nix Channel if not already done";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c ${channelInitScript}";
    };
  };
}
