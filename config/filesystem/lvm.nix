{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  boot.initrd.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;
}