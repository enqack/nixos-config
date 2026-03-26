{ config, lib, pkgs, ... }:
let
  cfg = config.modules.base.env;
in
{
  options.modules.base.env = {
    enable = lib.mkEnableOption "base env configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = rec {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";

      # Not officially in the specification
      XDG_BIN_HOME    = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
        "${pkgs.coreutils}/bin"
      ];
    };
  };
}
