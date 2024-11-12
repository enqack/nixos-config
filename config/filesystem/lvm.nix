{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;

  systemd.services."lvm-activate-stage2" = {
    description = "Activate LVM Pools in Stage Two";
    wants = [ "basic.target" ];
    before = [ "local-fs.target" ];
    after = [ "systemd-remount-fs.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.kmod}/bin/modprobe dm_mod";
      ExecStart = "${pkgs.lvm2}/bin/lvm vgchange -ay";
      RemainAfterExit = true;
    };
  };

}