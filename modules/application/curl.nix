{config, lib, pkgs, ...}:

let
  cfg = config.host.application.curl;
in
{
  options = {
    host.application.curl = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables curl";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
    ];
  };
}
