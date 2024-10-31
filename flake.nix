{
  description = "NixOS configuration with Home Manager";

  inputs = {
    # Main NixOS package source
    nixpkgs.url = "github:NixOS/nixpkgs";

    # Home Manager for managing user configurations
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # HyprPanel overlay
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs = { self, nixpkgs, home-manager, hyprpanel }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      # Define your NixOS configuration for the "flex" system
      flex = nixpkgs.lib.nixosSystem {
        inherit system;

        # Import nixpkgs with the HyprPanel overlay applied
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ hyprpanel.overlay ];
        };

        # Define modules and add configuration.nix
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}

