{ config, pkgs, ... }:

{
  imports = [
    # base profile for this profile
    ../desktop

    ../../../modules/linux/virtualization/libvirt
    ../../../modules/linux/virtualization/podman
    ../../../modules/linux/virtualization/virt-manager
  ];

  modules.virtualization.libvirt.enable = true;
  modules.virtualization.podman.enable = true;
  modules.virtualization.virt-manager.enable = true;
}
