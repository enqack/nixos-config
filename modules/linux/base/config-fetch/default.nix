{ config, lib, pkgs, ... }:

let
  cfg = config.modules.base.config-fetch;
  configRepo = "https://github.com/enqack/nixos-config.git";
  configUser = "sysadm";
  flagFile = "/var/lib/nixos-configuration-fetched";
  logFile = "/var/log/config-fetch.log";
  branchOrCommit = "main"; # Change to desired branch, tag, or commit hash

  fetchConfigScript = ''
    set -e

    export HOME=/home/${configUser}

    log() {
      echo "$(date -u +"[%Y-%m-%d %H:%M:%S UTC]") $@" | tee -a ${logFile}
    }

    if ! id ${configUser} >/dev/null 2>&1; then
      log "ERROR: User '${configUser}' does not exist. Exiting."
      exit 1
    fi

    ${pkgs.git}/bin/git config --global --add safe.directory /home/${configUser}/.config/nixos
    ${pkgs.coreutils}/bin/chown -R ${configUser}:users $HOME/.config/nixos

    if [ ! -d /home/${configUser}/.config/nixos/.git ]; then
      log "Configuration repository missing. Cloning..."
      ${pkgs.sudo}/bin/sudo -u ${configUser} ${pkgs.git}/bin/git clone --branch ${branchOrCommit} ${configRepo} /home/${configUser}/.config/nixos
    else
      log "Configuration repository exists. Ensuring it's on the correct branch or commit."
      ${pkgs.sudo}/bin/sudo -u ${configUser} ${pkgs.git}/bin/git -C /home/${configUser}/.config/nixos fetch origin
      ${pkgs.sudo}/bin/sudo -u ${configUser} ${pkgs.git}/bin/git -C /home/${configUser}/.config/nixos checkout ${branchOrCommit}
    fi

    if [ ! -L /etc/nixos ] || [ ! -d /etc/nixos ]; then
      log "Creating or fixing symlink for /etc/nixos..."
      ${pkgs.coreutils}/bin/ln -sf /home/${configUser}/.config/nixos /etc/nixos
    fi

    ${pkgs.coreutils}/bin/touch ${flagFile}
    log "Configuration checked and updated to branch/commit '${branchOrCommit}' at $(date)"
  '';
in
{
  options.modules.base.config-fetch = {
    enable = lib.mkEnableOption "base config-fetch configuration";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.config-fetch = {
      description = "Fetch and Update NixOS Configuration";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c ${fetchConfigScript}";
      };
    };
  };
}
