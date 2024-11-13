{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.wpa_supplicant
  ];

  networking = {
    # enable systemd-networkd
    useNetworkd = true;
    useDHCP = true;    
    dhcpcd.enable = true;
    networkmanager.enable = false;
  };

  systemd.network.enable = true;
  
  systemd.network.networks."10-enp" = {
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "ipv4";
  };

  systemd.network.networks."20-wlp" = {
    matchConfig.Name = "wlp*";
    networkConfig.DHCP = "ipv4";
  };

  networking.wireless.enable = true;

  networking.wireless.networks = {
    "MnT-AC" = {
      psk = "burnitdown";
    };
  }; 
}

