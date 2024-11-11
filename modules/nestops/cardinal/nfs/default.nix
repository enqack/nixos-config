{ config, lib, pkgs, ... }:

{
  options.nestops.cardinal.nfs = {
      enable = lib.mkEnableOption "Enables Cardinal's NFS Daemon";

  };

  config = lib.mkIf config.nestops.cardinal.nfs.enable {
    environment.systemPackages = with pkgs; [
      podman
    ];

    systemd.services."nestops-cardinal-nfs" = {
      wantedBy = [ "multi-user.target" ];
      enable = true;
      serviceConfig = {
        ExecStartPre = [  ];
        ExecStart = [  ];
      };
    };
  };
}