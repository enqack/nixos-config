{ config, lib, pkgs, ... }:
let
  cfg = config.modules.virtualization.libvirt;
in
{
  options.modules.virtualization.libvirt = {
    enable = lib.mkEnableOption "virtualization libvirt configuration";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
    };

    users.users.qemu-libvirtd = {
      extraGroups = [ "video" "render" ];
    };
  };
}
