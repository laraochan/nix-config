{
  description = "larao's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    org-babel.url = "github:emacs-twist/org-babel";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    {
      darwinConfigurations."m2-mbp" =
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self inputs;
          };

          modules = [
            ./darwin.nix

            home-manager.darwinModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs;
                };

                users.larao = import ./home.nix;
              };
            }
          ];
        };
    };
}
