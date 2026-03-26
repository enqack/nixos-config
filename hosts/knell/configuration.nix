{ ... }:

{
  networking = {
    hostName = "knell";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/sda"; })

    ../../profiles/linux/roles/server
  ];
}
