{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    age-plugin-yubikey
    pam_u2f
    pamtester
    yubikey-manager
    yubikey-personalization
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
