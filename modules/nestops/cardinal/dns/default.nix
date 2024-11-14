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
        Environment = "POD_NAME=nestops-cardinal-dns";
        ExecStartPre = "-${pkgs.podman}/bin/podman pod exists $POD_NAME";
        ExecStart = "-${pkgs.podman}/bin/podman run -d -p 67:67 $POD_NAME";
      };
    };

  };
}