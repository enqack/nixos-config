{ pkgs, ... }:

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

  systemd.network.networks."20-wl" = {
    matchConfig.Name = "wl*";
    networkConfig.DHCP = "ipv4";
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  networking.wireless.networks = {
    "MnT-AC" = {
      pskRaw = "6b1778d7f0ee5e68470601a031e9e3f540de183de5d6049f540caff3d5b72ff0";
      priority = 1;
    };
    "stvPhone" = {
      pskRaw = "8437115c97245e3e164f71f3ffd5f973d8b2da761a1e36685d9a597f6de74eab";
      priority = 2;
    };
    "VerNet5G" = {
      pskRaw = "4275233bbfa42c3407a35b5a266fe0dca37017dd36d331326832fd6a7feeecfe";
    };
  }; 
}


