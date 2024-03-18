{
  description = "The entry-point flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    inherit (self) outputs;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forEachSystem = f: nixpkgs.lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });

  in {
    nixosModules = import ./modules;
    overlays = import ./overlays { inherit inputs outputs; };
    nixosPackages = forEachSystem (pkgs: import ./packages { inherit pkgs; });
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

    nixosConfigurations = {

      knell = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/knell/configuration.nix
        ];
        specialArgs = { inherit inputs outputs; };
      };

      grillage = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/grillage/configuration.nix
        ];
        specialArgs = { inherit inputs outputs; };
      };

      bellfound = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/bellfound/configuration.nix
        ];
        specialArgs = { inherit inputs outputs; };
      };

    };
  };
}
