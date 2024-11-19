{ config, pkgs, ... }:

{
  imports = [
    # base profile for this profile
    ../desktop
  ];

  # List packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
