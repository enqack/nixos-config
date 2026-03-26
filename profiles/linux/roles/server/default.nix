{ config, pkgs, ... }:

{
  imports = [
    # base profile
    ../base

    ../../../../modules/linux/hardware/graphics

    ../../../../modules/linux/virtualization/libvirt
    ../../../../modules/linux/virtualization/podman
    ../../../../modules/linux/virtualization/virt-manager
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
