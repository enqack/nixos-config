{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  boot.initrd.services.lvm.enable = true;
  services.lvm.boot.thin.enable = true;

  systemd.services."lvm-activate" = {
    wantedBy = [ "initrd-root-device.target" ];
    before = [ "initrd-root-fs.target" ];
    serviceConfig = {
      ExecStart = [
        "${pkgs.lvm2}/bin/vgscan"
        "${pkgs.lvm2}/bin/vgchange -ay"
      ];
    };
  };
}