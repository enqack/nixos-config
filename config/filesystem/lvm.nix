{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;
  boot.initrd.preLVMCommands = "lvm vgchange -ay";
}