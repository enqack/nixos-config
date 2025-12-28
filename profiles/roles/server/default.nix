{ config, pkgs, ... }:

{
  imports = [
    # base profile
    ../base

    ../../../modules/hardware/graphics

    ../../../modules/virtualization/libvirt
    ../../../modules/virtualization/podman
    ../../../modules/virtualization/virt-manager
  ];

  modules.hardware.graphics.enable = true;
  modules.virtualization.libvirt.enable = true;
  modules.virtualization.podman.enable = true;
  modules.virtualization.virt-manager.enable = true;

  services.cockpit = {
    enable = true;
    openFirewall = true;
    settings = {
      Session = {
        Banner = "/etc/issue.plaintext";
      };
    };  
  };
}
