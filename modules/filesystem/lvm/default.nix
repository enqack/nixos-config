{ config, lib, pkgs, ... }:
let
  cfg = config.modules.filesystem.lvm;
in
{
  options.modules.filesystem.lvm = {
    enable = lib.mkEnableOption "filesystem lvm configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lvm2
      mdadm
    ];

    services.lvm.enable = true;
    boot.initrd.services.lvm.enable = true;
  };
}
