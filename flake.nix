{
  description = "NixOS configuration with Home Manager";

  inputs = {
    # Main NixOS package source
    nixpkgs.url = "github:NixOS/nixpkgs";

    # Home Manager for managing user configurations
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      
      reactor = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

        modules = [
          ./hosts/reactor/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      flex = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

        modules = [
          ./hosts/flex/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

    };
  };
}

