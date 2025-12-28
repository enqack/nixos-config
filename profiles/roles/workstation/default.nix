{ config, pkgs, ... }:

{
  imports = [
    # base profile for this profile
    ../desktop

    ../../../modules/virtualization/libvirt
    ../../../modules/virtualization/podman
    ../../../modules/virtualization/virt-manager
  ];

  modules.virtualization.libvirt.enable = true;
  modules.virtualization.podman.enable = true;
  modules.virtualization.virt-manager.enable = true;
}
