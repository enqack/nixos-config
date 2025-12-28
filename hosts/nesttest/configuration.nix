{ config, pkgs, disko, ... }:

{
  networking = {
    hostName = "nesttest";
  };

  imports = [
    ./hardware-configuration.nix
    (import ./disko-configuration.nix { device = "/dev/vda"; })

    ../../profiles/roles/server
    ../../profiles/hardware/vm-guest
    
    # Import base modules needed for boot
    ../../modules/system/boot
    ../../modules/base/nix # usually needed for nix command
    ../../modules/base/env # environment variables
  ];

  modules.system.boot.enable = true;
  #modules.system.boot.grubDevice = "/dev/vda";
  modules.system.boot.efiSupport = true; 

  # Assuming base modules are needed too for a functional system
  modules.base.nix.enable = true;
  modules.base.env.enable = true;

  boot.initrd.systemd.emergencyAccess = true;
  #systemd.services."emergency".serviceConfig.ExecStart = [ "/usr/lib/systemd/systemd-sulogin-shell emergency" ];
}
