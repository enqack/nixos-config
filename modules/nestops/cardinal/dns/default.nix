{ config, lib, pkgs, ... }:

{
  options.nestops.cardinal.dns = {
      enable = lib.mkEnableOption "Enables Cardinal's DNS Daemon";

  };

  config = lib.mkIf config.nestops.cardinal.dns.enable {
    environment.systemPackages = with pkgs; [
      podman
    ];

    systemd.services."nestops-cardinal-dns" = {
      wantedBy = [ "multi-user.target" ];
      enable = true;
      serviceConfig = {
        ExecStartPre = [  ];
        ExecStart = [  ];
      };
    };
  };
}