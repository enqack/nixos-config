{config, lib, pkgs, ...}:

let
  cfg = config.host.application.wget;
in
{
  options = {
    host.application.wget = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables wget";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
    ];
  };
}
