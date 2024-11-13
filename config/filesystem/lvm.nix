{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;
  # boot.initrd.systemd.extraBin = {
  #   lvm = "${pkgs.lvm2}/bin/lvm";
  # };
  #boot.kernelParams = [ "systemd.log_level=debug" "systemd.log_target=console" ];

  systemd.services.lvm2-lvmetad = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" "systemd-journald.service" ];
  };

  systemd.services.lvm2-activation = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "lvm2-lvmetad.service" ];
    requires = [ "lvm2-lvmetad.service" ];
  };
}