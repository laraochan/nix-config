{
  description = "larao's nix-darwin Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#laraos-MacBook-Pro
    darwinConfigurations."laraos-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit self;
      };

      modules = [
        ./darwin.nix

        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.larao = import ./home.nix;
          };
        }
      ];
    };
  };
}
