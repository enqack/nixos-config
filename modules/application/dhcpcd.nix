{config, lib, pkgs, ...}:

let
  cfg = config.host.application.dhcpcd;
in
{
  options = {
    host.application.dhcpcd = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables dhcpcd (dhcp client daemon)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dhcpcd
    ];
  };
}
