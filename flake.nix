{
  description = "laraos MacBook Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      ...
    }:
    let
      username = "larao";
      hostname = "laraos-MacBook-Pro";

      configuration =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            neovim
          ];

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

	  system.defaults.dock = {
	    show-recents = false;

	    persistent-apps = [
	      { app = "/Applications/Google Chrome.app"; }
	      { app = "/Applications/Ghostty.app"; }
	    ];
	  };

          system.primaryUser = username;
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          nix-homebrew.darwinModules.nix-homebrew

          {
            nix-homebrew = {
              enable = true;
              user = username;

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              mutableTaps = false;
            };
          }

          ({ config, pkgs, ... }: {
            environment.systemPackages = with pkgs; [
              neovim
	      codex
            ];

            homebrew = {
              enable = true;
              taps = builtins.attrNames config.nix-homebrew.taps;

              brews = [];

              casks = [
                "google-chrome"
		"ghostty"
              ];

              onActivation = {
                autoUpdate = false;
                upgrade = false;
              };
            };
          })
        ];
      };
    };
}
