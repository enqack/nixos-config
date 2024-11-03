{ config, pkgs, lib, ... }:
let
  nixPathString = lib.concatStringsSep ":" config.nix.nixPath;
in
{
  systemd.services.nix-index-update = {
    description = "Update nix-index cache with limited resources";
    wants = [ "nix-index-update.timer" ];

    serviceConfig = {
      Type = "oneshot";
      Environment = [ "NIX_PATH=${nixPathString}" ];
      ExecStart = [ "${pkgs.coreutils}/bin/nice -n 19 ${pkgs.nix-index}/bin/nix-index" ];
      MemoryMax = "6G";                  # Limit memory usage to 4GB
      CPUQuota = "50%";                  # Limit CPU usage to 50%
      IOSchedulingClass = "beste-ffort";
      IOSchedulingPriority = "4";
    };
  };

  systemd.timers.nix-index-update = {
    description = "Run nix-index update weekly";
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  system.activationScripts.nixIndexUpdateTimer = {
    text = ''
      # Start the nix-index-update.timer if it's not already active
      ${pkgs.systemd}/bin/systemctl start nix-index-update.timer
    '';
  };
}
