{ ... }:

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 90d --max-freed 256*1240*1024 --log-format bar-with-logs";
  };
}

