{ config, lib, pkgs, ... }:

{
  options.nestops.cardinal.tftp = {
      enable = lib.mkEnableOption "Enables Cardinal's TFTP Daemon";

  };

  config = lib.mkIf config.nestops.cardinal.tftp.enable {
    environment.systemPackages = with pkgs; [
      podman
    ];

    systemd.services."nestops-cardinal-tftp" = {
      wantedBy = [ "multi-user.target" ];
      enable = true;
      serviceConfig = {
        ExecStartPre = [  ];
        ExecStart = [  ];
      };
    };
  };
}