{
  description = "larao's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    org-babel.url = "github:emacs-twist/org-babel";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, org-babel, ... }: {
    nixosConfigurations = {
      thinkpad-e14-gen5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.larao = ./home.nix;
          }
        ];
      };
    };
  };
}
