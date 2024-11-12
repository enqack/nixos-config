{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;

  boot.initrd.systemd.services.lvm-activate = {
    description = "Activate LVM Pools";
    wants = [ "basic.target" ];
    before = [ "basic.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.kmod}/bin/modprobe dm_mod";
      ExecStart = "${pkgs.lvm2}/bin/lvm vgchange -ay";
    };
  };
}