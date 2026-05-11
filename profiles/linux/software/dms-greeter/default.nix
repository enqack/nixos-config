{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };
  
  programs.dankMaterialShell.greeter = {
    enable = true;

    compositor = {
      name = "niri";
      customConfig = ''
        hotkey-overlay {
            skip-at-startup
        }

        environment {
            DMS_RUN_GREETER "1"
        }

        output "DP-1" {
          mode "1440x3440@99.998"
          position x=0 y=0
        }
        output "DP-2" {
          mode "1440x3340@120.0"
          position x=0 y=1440
          focus-at-startup
        }

        layout {
          background-color "#000000"
          shadow {
            on
          }
        }
      '';
    };
    configFiles = [
      "/home/sysop/.config/DankMaterialShell/settings.json"
      "/home/sysop/.local/state/DankMaterialShell/session.json"
    ];
  };
}
