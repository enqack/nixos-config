{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.virtualization.virt-manager;
in
{
  options.modules.virtualization.virt-manager = {
    enable = lib.mkEnableOption "darwin virtualization virt-manager configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice-gtk
    ];
  };
}
