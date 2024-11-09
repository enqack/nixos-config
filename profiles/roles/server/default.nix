{ config, pkgs, ... }:

{
  imports = [
    # base profile
    ../base

    ../../../config/virtualization/libvirt.nix
    ../../../config/virtualization/podman.nix
    ../../../config/virtualization/virt-manager.nix
  ];
}