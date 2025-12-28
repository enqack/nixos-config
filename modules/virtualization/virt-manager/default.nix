{ config, lib, pkgs, ... }:
let
  cfg = config.modules.virtualization.virt-manager;
in
{
  options.modules.virtualization.virt-manager = {
    enable = lib.mkEnableOption "virtualization virt-manager configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      virt-viewer
      spice-gtk
    ];    
  };
}
