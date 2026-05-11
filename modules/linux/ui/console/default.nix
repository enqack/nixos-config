{ config, lib, pkgs, ... }:
let
  cfg = config.modules.ui.console;
in
{
  options.modules.ui.console = {
    enable = lib.mkEnableOption "ui console configuration";
  };

  config = lib.mkIf cfg.enable {
    # Setup console
    console = {
      earlySetup = true;
      font = "ter-v32n";
      useXkbConfig = true;
      packages = with pkgs; [ terminus_font ];
    };
  };
}
