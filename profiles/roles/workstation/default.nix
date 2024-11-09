{ config, pkgs, ... }:

{
  imports = [
    # base profile for this profile
    ../desktop

    ../../../config/virtualization/libvirt.nix
    ../../../config/virtualization/podman.nix
    ../../../config/virtualization/virt-manager.nix
  ];
}