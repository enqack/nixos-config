{ pkgs, inputs, ... }:

{
    programs.steam = {
        enable = true;
        extest.enable = true;

        protontricks.enable = true;
        gamescopeSession.enable = true;

        extraPackages = with pkgs; [
          mangohud
          gamescope
          gamescope-wsi
        ];

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
    };
    
    programs.gamescope.enable = true;
    hardware.steam-hardware.enable = true;
    hardware.graphics.enable32Bit = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
}

