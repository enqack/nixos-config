{ config, pkgs, ... }:

{
  # Setup console
  console = {
    earlySetup = true;
    font = "ter-v32n";
    useXkbConfig = true;
    packages = with pkgs; [ terminus_font ];
  };
}
