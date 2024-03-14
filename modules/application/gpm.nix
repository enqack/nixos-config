{config, lib, pkgs, ...}:

let
  cfg = config.host.application.gpm;
in
{
  options = {
    host.application.gpm = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables wget";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gpm
    ];
  };
}
