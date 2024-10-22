{
  description = "Ryan's darwin system";

  inputs = {
    # Package sets
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    #nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    #nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    ##nixpkgs-with-patched-kitty.url = github:azuwis/nixpkgs/kitty;
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Environment/system management
    #darwin.url = "github:lnl7/nix-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    #darwin.url = "github:lnl7/nix-darwin/release-23.05";
    #darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies
  #outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;
    #inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      ##overlays = attrValues self.overlays ++ singleton (
      ##  # Sub in x86 version of packages that don't build on Apple Silicon yet
      ##  final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      ##    inherit (final.pkgs-x86)
      ##      idris2
      ##      nix-index
      ##      niv
      ##      purescript;
      ##  })
      ##);
    }; 
  in
  {
    # My `nix-darwin` configs
      
     services.nix-daemon.enable = true;
    darwinConfigurations = rec {
      TD-C02FG1PYMD6N = darwinSystem {
        system = "x86_64-darwin";
        modules = [ 
          # Main `nix-darwin` config
          ./configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rhousand = import ./home.nix;            
          }
        ];
      };
    };
 };
}

  
