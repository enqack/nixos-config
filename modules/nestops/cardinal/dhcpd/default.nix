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
        ExecStartPre = [  ];
        ExecStart = [ "podman" "run" "-d" "-p" "67:67" "nestops-cardinal-dhcpd" ];
      };
    };
  };
}