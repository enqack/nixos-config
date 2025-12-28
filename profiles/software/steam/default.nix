{ pkgs, inputs, ... }:

{
    programs.steam = {
        enable = true;
        extest.enable = true;

        protontricks.enable = true;
        gamescopeSession.enable = true;

        extraCompatPackages = with pkgs; [
            proton-ge-bin
            mangohud
            gamescope
            gamescope-wsi
        ];
    };
    programs.gamescope.enable = true;
    hardware.steam-hardware.enable = true;
    hardware.xpadneo.enable = true;
    hardware.graphics.enable32Bit = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
}
