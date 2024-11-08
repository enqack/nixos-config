{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];
}