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
    wants = [ "initrd-root-fs.target" ];
    before = [ "initrd-root-fs.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.kmod}/bin/modprobe dm_mod";
      ExecStart = "${pkgs.lvm2}/bin/lvm vgchange -ay";
    };
  };
}