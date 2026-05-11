{ config, pkgs, ... }:

{
  imports = [
    # base profile for this profile
    ../desktop

    # bring in yubikey support
    ../../../darwin/software/yubico
  ];

  # List packages installed in laptop profile.
  environment.systemPackages = with pkgs; [

  ];
}
