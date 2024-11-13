{ config, lib, pkgs, modulesPath, ... }:

{
    boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" ];
}