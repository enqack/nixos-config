{config, lib, pkgs, ...}:

let
  cfg = config.host.application.glow;
in
{
  options = {
    host.application.glow = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables glow";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      glow
    ];
  };
}
