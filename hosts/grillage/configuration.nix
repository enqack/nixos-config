{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/linux/roles/server

    ../../modules/linux/nestops/cardinal/dhcpd
    ../../modules/linux/nestops/cardinal/dns
  ];

  config = {
    networking = {
      hostName = "grillage";
    };

    systemd.network.networks."10-enp" = {
      matchConfig.Name = "enp*";
      networkConfig = {
        DHCP = lib.mkForce "no";
        Address = "192.168.10.6/24";
        Gateway = "192.168.10.1";
        DNS = [
          "192.168.10.1"
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };

    nestops.cardinal.dhcpd.enable = true;
    nestops.cardinal.dns.enable = true;

    #
    # Steam Dedicated Game Server Setup
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      protonup-ng
      steamcmd
    ];
  };
}
