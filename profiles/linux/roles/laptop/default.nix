{ lib, pkgs, ... }:

{
  imports = [
    # base profile for this profile
    ../desktop

    # bring in yubikey support
    ../../../linux/software/yubico
  ];

  # List packages installed in laptop profile.
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
    # cpuFreqGovernor = "schedutil"; #power, performance, ondemand
  };

  services.power-profiles-daemon.enable = true;
  
  services.thermald.enable = true;

  services.logind.settings.Login = {
    #HandlePowerKey = lib.mkForce "suspend";
  
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  
    #KillUserProcesses = false;
  };  
}
