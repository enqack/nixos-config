{
  description = "The entry-point flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manger = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    inherit (self) outputs;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forEachSystem = f: nixpkgs.lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });

    users = [
      "sysop"
    ];
  in {
    nixosModules = import ./modules;
    overlays = import ./overlays { inherit inputs outputs; };
    nixosPackages = forEachSystem (pkgs: import ./packages { inherit pkgs; });
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

    nixosConfigurations = {

      knell = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/knell/configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.sysop = import ./users/sysop;
          }
        ];
        specialArgs = { inherit inputs outputs; };
      };

      grillage = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/grillage/configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.sysop = import ./users/sysop;
          }
        ];
        specialArgs = { inherit inputs outputs; };
      };

      belfound = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/belfound/configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.sysop = import ./users/sysop;
          }
        ];
        specialArgs = { inherit inputs outputs; };
      };

    };
  };
}
