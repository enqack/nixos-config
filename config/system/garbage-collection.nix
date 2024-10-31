{ config, pkgs, lib, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 90d --delete-generations +25 --max-freed 256*1240*1024 --log-format bar-with-logs";
  };
}

