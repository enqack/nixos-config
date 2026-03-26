{ ... }:

{
  networking = {
    hostName = "vector";
  };

  imports = [
    ./hardware-configuration.nix
    # (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/linux/roles/laptop
    ../../profiles/linux/roles/workstation
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
}
