{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    device-mapper
    lvm2
    mdadm
  ];

  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;
  boot.initrd.extraUtils = [ pkgs.lvm2 ];
}