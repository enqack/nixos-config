{config, lib, pkgs, ...}:

let
  cfg = config.host.application.tmux;
in
{
  options = {
    host.application.tmux = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables tmux (terminal multiplexer)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };
}
