{ pkgs, ... }:

let
  cptv = import ../../../../pkgs/cptv { pkgs = pkgs; };
in

{
  imports = [
    # base profile
    ../base
  ];

  # List packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    alacritty
    ansi2html
    calcurse
    cmatrix
    cptv
    firefox
    gomatrix
    google-chrome
    kitty
    libsixel
    libxkbcommon
    mesa
    vscode
    wezterm
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "mas"
    ];
    casks = [
      "alt-tab"
      "blender@lts"
      "claude"
      "dockdoor"
      "elgato-stream-deck"
      "krita"
      "raycast"
      "rectangle"
      "utm"
      "zed"
      "zettlr"
    ];
    masApps = {
      "Apple Configurator" = 1037126344;
      "Gifski" = 1351639930;
      "Bitwarden" = 1352778147;
      "Session Pomodoro" = 1521432881;
    };
  };

}
