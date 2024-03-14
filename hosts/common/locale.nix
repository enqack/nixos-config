{ lib, ... }:

{
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
    };
  };
  time.timeZone = lib.mkDefault "UTC";
}
