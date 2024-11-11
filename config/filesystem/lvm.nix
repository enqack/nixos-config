{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  boot.initrd.services.lvm.enable = true;
  services.lvm.boot.thin.enable = true;

  boot.initrd.postDeviceCommands = ''
    vgscan
    vgchange -ay
  '';
}