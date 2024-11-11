{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    inputs.sops-nix.url = "github:Mic92/sops-nix";
    inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, home-manager, sops-nix }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      
      reactor = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
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
          config.allowUnfree = true;
        };

        modules = [
          ./hosts/flex/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      nixany = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = [
          disko.nixosModules.disko
          ./hosts/nixany/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      nesttest = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = [
          disko.nixosModules.disko
          ./hosts/nesttest/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

    };
  };
}

