{ config, lib, pkgs, ... }:

{
  options.nestops.cardinal.dhcpd = {
      enable = lib.mkEnableOption "Enables Cardinal's DHCP Daemon";

  };

  config = lib.mkIf config.nestops.cardinal.dhcpd.enable {
    environment.systemPackages = with pkgs; [
      podman
    ];

    systemd.services."nestops-cardinal-dhcpd" = {
      wantedBy = [ "multi-user.target" ];
      enable = true;
      serviceConfig = {
        Environment = "POD_NAME=nestops-cardinal-dhcpd";
        ExecStartPre = /bin/sh -c '[ "$(podman pod exists "$POD_NAME" && echo true || echo false)" = "true" ]';
        ExecStart = [ "podman" "run" "-d" "-p" "67:67" $POD_NAME ];
      };
    };
  };
}