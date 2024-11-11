{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lvm2
    mdadm
  ];

  boot.initrd.services.lvm.enable = true;
  services.lvm.boot.thin.enable = true;

  boot.initrd.postDeviceCommands = ''
    # List all open file descriptors for LVM processes and attempt to release them
    for pid in $(pgrep -f lvm); do
      lsof -p $pid | grep -E "^[0-9]+r" | awk '{print $1}' | xargs -I {} sh -c "echo closing FD {}; exec {}<&-"
    done
  '';
}