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
  boot.kernelParams = [ "systemd.log_level=debug" "systemd.log_target=console" ]
}