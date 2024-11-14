{
  description = "NixOS configuration for NestOps";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, disko, home-manager, sops-nix }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # List of host definitions with extra modules
    hosts = [
      { name = "reactor"; extraModules = []; }
      { name = "flex"; extraModules = []; }
      { name = "nixany"; extraModules = []; }
      { name = "nesttest"; extraModules = []; }
      { name = "knell"; extraModules = []; }
      { name = "grillage"; extraModules = [ sops-nix.nixosModules.sops ]; }
    ];

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

      modules = [
        disko.nixosModules.disko
        (./hosts/${host.name}/configuration.nix)
        home-manager.nixosModules.home-manager
      ] ++ host.extraModules;
    };

  in {
    # Generate host configurations from `hosts` list
    nixosConfigurations = lib.genAttrs 
      (map (h: h.name) hosts) 
      (hostName: mkHost 
        (builtins.elemAt hosts (findIndex hostName hosts))
      );
  };
}
