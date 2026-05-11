{ config, lib, pkgs, ... }:
let
  cfg = config.modules.virtualization.libvirt;
in
{
  options.modules.virtualization.libvirt = {
    enable = lib.mkEnableOption "virtualization libvirt configuration";

    authorizedKeys = lib.mkOption {
      description = "List of authorized key strings";
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
    };

    users.users.qemu-libvirtd = {
      extraGroups = [ "video" "render" ];
    };

    users.users.libvirt = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "libvirtd" ];
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };
  };
}
