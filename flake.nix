{
  description = "NixOS configuration for NestOps";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-search-tv.url = "github:3timeslazy/nix-search-tv?ref=v2.2.3";
    nix-search-tv.inputs.nixpkgs.follows = "nixpkgs";

    spnav-mouse.url = "github:enqack/spnav-mouse";
    spnav-mouse.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, disko, sops-nix, cachix, nix-search-tv, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # Load the nix file with host definitions
    hosts = import ./hosts.nix;

    # Validation function to ensure each host has the correct fields
    isValidHost = host:
      lib.isAttrs host &&
      lib.hasAttr "name" host && lib.isString host.name &&
      lib.hasAttr "extraModules" host && lib.isList host.extraModules &&
      lib.hasAttr "critical" host && lib.isBool host.critical;

    # Filter out invalid hosts and keep only valid ones
    validHosts = lib.filter isValidHost hosts;

    # Define fallback hosts for any missing critical hosts
    fallbackHosts = [
      { name = "scalar"; extraModules = []; critical = true; }
      { name = "reactor"; extraModules = []; critical = true; }
      { name = "catalyst"; extraModules = []; critical = true; }
      { name = "tartarus"; extraModules = []; critical = true; }
      { name = "elysium"; extraModules = []; critical = true; }
    ];

    # Combine valid hosts with fallback critical hosts (only if missing)
    allHosts = lib.concatMap (host:
      if lib.any (h: h.name == host.name) validHosts then [] else [host]
    ) fallbackHosts ++ validHosts;

    # Function to find the index of an element by name
    findIndex = name: list:
      let
        names = map (h: h.name) list;
      in
        builtins.elemAt (builtins.filter (i: builtins.elemAt names i == name) (lib.range 0 (builtins.length names - 1))) 0;

    # Function to generate each host configuration
    mkHost = host: lib.nixosSystem {
      inherit system;

      pkgs = import nixpkgs {
        inherit system;
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
      ] ++ host.extraModules;
    };

  in {
    # Generate host configurations from `hosts` list
    nixosConfigurations = lib.genAttrs
      (map (h: h.name) allHosts)
      (hostName: mkHost
        (builtins.elemAt allHosts (findIndex hostName allHosts))
      );
  };
}
