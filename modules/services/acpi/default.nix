{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.acpi;
in
{
  options.modules.services.acpi = {
    enable = lib.mkEnableOption "services acpi configuration";
  };

  config = lib.mkIf cfg.enable {
    services.acpid.enable = true;
    services.upower.enable = true;
  };
}
