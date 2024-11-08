{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      vscode = super.vscode.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
          "--ozone-platform-hint=auto"
          "--unity-launch %F"
        ];
      };
    })
  ];
}
