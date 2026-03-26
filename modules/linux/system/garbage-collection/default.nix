{ config, lib, pkgs, ... }:
let
  cfg = config.modules.system.garbage-collection;
in
{
  options.modules.system.garbage-collection = {
    enable = lib.mkEnableOption "system garbage-collection configuration";
  };

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 90d --max-freed 256*1240*1024 --log-format bar-with-logs";
    };
  };
}
