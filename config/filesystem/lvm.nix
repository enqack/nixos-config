{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;

  boot.initrd.systemd.services."lvm-activate-initrd" = {
    description = "Activate LVM Pools in Initrd for Root Device";
    wants = [ "initrd-root-device.target" ];
    before = [ "initrd-root-device.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.kmod}/bin/modprobe dm_mod";
      ExecStart = "${pkgs.lvm2}/bin/lvm vgchange -ay mainpool";
      RemainAfterExit = true;
    };
  };
}