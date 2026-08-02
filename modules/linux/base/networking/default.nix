{ config, lib, pkgs, ... }:
let
  cfg = config.modules.base.networking;
in
{
  options.modules.base.networking = {
    enable = lib.mkEnableOption "base networking configuration";
    backend = lib.mkOption {
      type = lib.types.enum [ "networkd" "networkmanager" ];
      default = "networkd";
      description = "Network backend: systemd-networkd or NetworkManager.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ pkgs.iwd ];
    }

    (lib.mkIf (cfg.backend == "networkd") {
      networking.useNetworkd = true;
      networking.networkmanager.enable = false;

      systemd.network.enable = true;
      systemd.network.networks."10-enp" = {
        matchConfig.Name = "enp*";
        networkConfig.DHCP = "ipv4";
      };
      systemd.network.networks."20-wl" = {
        matchConfig.Name = "wl*";
        networkConfig.DHCP = "ipv4";
      };

      networking.wireless.enable = false;
      networking.wireless.userControlled.enable = true;
      networking.wireless.iwd = {
        enable = true;
        settings.Settings.AutoConnect = true;
      };
    })

    (lib.mkIf (cfg.backend == "networkmanager") {
      networking.useNetworkd = false;
      networking.networkmanager.enable = true;
      networking.networkmanager.wifi.backend = "iwd";
    })
  ]);
}

