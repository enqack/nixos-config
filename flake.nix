{
  description = "NixOS and Nix-Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin?ref=nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    distro-grub-themes.inputs.nixpkgs.follows = "nixpkgs";

    nix-search-tv.url = "github:3timeslazy/nix-search-tv?ref=v2.2.3";
    nix-search-tv.inputs.nixpkgs.follows = "nixpkgs";

    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms.inputs.nixpkgs.follows = "nixpkgs-unstable";

    spnav-mouse.url = "github:enqack/spnav-mouse";
    spnav-mouse.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      disko,
      sops-nix,
      distro-grub-themes,
      nix-search-tv,
      dms,
      ...
    }:
    let
      lib = nixpkgs.lib;

      isDarwin = sys: lib.hasSuffix "-darwin" sys;

      # Load the nix file with host definitions
      hosts = import ./hosts.nix;

      # Validation function to ensure each host has the correct fields
      isValidHost =
        host:
        lib.isAttrs host
        && lib.hasAttr "name" host
        && lib.isString host.name
        && lib.hasAttr "system" host
        && lib.isString host.system
        && lib.hasAttr "extraModules" host
        && lib.isList host.extraModules
        && lib.hasAttr "critical" host
        && lib.isBool host.critical;

      # Filter out invalid hosts and keep only valid ones
      validHosts = lib.filter isValidHost hosts;

      # Define fallback hosts for any missing critical hosts
      fallbackHosts = [
        {
          name = "forte";
          system = "aarch64-darwin";
          extraModules = [ ];
          critical = true;
        }
        {
          name = "scalar";
          system = "x86_64-linux";
          extraModules = [ ];
          critical = true;
        }
        {
          name = "reactor";
          system = "x86_64-linux";
          extraModules = [ ];
          critical = true;
        }
        {
          name = "catalyst";
          system = "x86_64-linux";
          extraModules = [
            dms.nixosModules.dankMaterialShell
            dms.nixosModules.greeter
          ];
          critical = true;
        }
        {
          name = "tartarus";
          system = "x86_64-linux";
          extraModules = [
            dms.nixosModules.dankMaterialShell
            dms.nixosModules.greeter
          ];
          critical = true;
        }
        {
          name = "elysium";
          system = "x86_64-linux";
          extraModules = [
            dms.nixosModules.dankMaterialShell
            dms.nixosModules.greeter
          ];
          critical = true;
        }
      ];

      # Combine valid hosts with fallback critical hosts (only if missing)
      allHosts =
        lib.concatMap (
          host: if lib.any (h: h.name == host.name) validHosts then [ ] else [ host ]
        ) fallbackHosts
        ++ validHosts;

      linuxHosts = lib.filter (h: !(isDarwin h.system)) allHosts;
      darwinHosts = lib.filter (h: isDarwin h.system) allHosts;

      mkLinuxHost =
        host:
        nixpkgs.lib.nixosSystem {
          system = host.system;

          pkgs = import nixpkgs {
            system = host.system;
            config.allowUnfree = true;
          };

          specialArgs = {
            inherit inputs;
          };

          modules = [
            disko.nixosModules.disko
            ./hosts/${host.name}/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            distro-grub-themes.nixosModules.x86_64-linux.default
          ]
          ++ host.extraModules;
        };

      mkDarwinHost =
        host:
        nix-darwin.lib.darwinSystem {
          system = host.system;

          pkgs = import nixpkgs {
            system = host.system;
            config.allowUnfree = true;
          };

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/${host.name}/configuration.nix
            home-manager.darwinModules.home-manager
            sops-nix.darwinModules.sops
          ]
          ++ host.extraModules;
        };

    in
    {
      nixosConfigurations = lib.listToAttrs (
        map (h: { name = h.name; value = mkLinuxHost h; }) linuxHosts
      );

      darwinConfigurations = lib.listToAttrs (
        map (h: { name = h.name; value = mkDarwinHost h; }) darwinHosts
      );
    };
}
