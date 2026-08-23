{
  description = "Multi-host nix-darwin and NixOS configuration";

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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    obsidian-extensions = {
      url = "github:karaolidis/nix-obsidian-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      username = "larao";
      specialArgs = { inherit inputs self username; };
    in
    {
      # Add another Mac by copying a directory under hosts/darwin and adding
      # one darwinSystem entry here.
      darwinConfigurations."laraos-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [ ./hosts/darwin/laraos-macbook-pro ];
      };

      # This is an installable template. Replace its hardware configuration
      # and hostname when adding the first physical NixOS machine.
      nixosConfigurations.nixos-example = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [ ./hosts/nixos/nixos-example ];
      };

      nixosConfigurations.thinkpad-e14-gen5 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [ ./hosts/nixos/thinkpad-e14-gen5 ];
      };

      formatter = {
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      };
    };
}
