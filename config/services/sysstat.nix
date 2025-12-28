{ pkgs, ... }:

{
  services.sysstat = {
    enable = true;
    collect-args = "-S XALL 1 1";
  };

  environment.systemPackages = with pkgs; [
    sysstat
  ];
}