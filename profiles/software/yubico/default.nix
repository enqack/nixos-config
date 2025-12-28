{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    age-plugin-yubikey
    pam_u2f
    pamtester
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-touch-detector
    yubioath-flutter
  ];

  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.u2f = {
    enable = false;
    control = "sufficient"; # one of "required", "requisite", "sufficient", "optional"
    settings = {
      origin = "pam://yubi";
      cue = true;
    };
  };

  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = false;
  };

  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];

  # Lock/unlock on removal/inserting yubikey
  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
}