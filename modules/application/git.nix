{config, lib, pkgs, ...}:

let
  cfg = config.host.application.git;
in
{
  options = {
    host.application.git = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables git";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
