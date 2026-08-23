{
  config,
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../common
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = import ../../home/larao;
  };

  nix-homebrew = {
    enable = true;
    user = username;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

  environment.systemPackages = with pkgs; [ codex ];

  # Home Manager reads this value from the nix-darwin user definition.
  users.users.${username}.home = "/Users/${username}";

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [ ];
    casks = [
      "discord"
      "ghostty"
      "google-chrome"
      "raycast"
      "spotify"
    ];
    onActivation = {
      autoUpdate = false;
      upgrade = false;
    };
  };

  system.defaults = {
    dock = {
      show-recents = false;
      persistent-apps = [
        { app = "/Applications/Google Chrome.app"; }
        { app = "/Applications/Ghostty.app"; }
        { app = "/Applications/Discord.app"; }
        { app = "/Applications/Spotify.app"; }
      ];
    };

    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
      # Free Command-Space from Input Sources and Spotlight so Raycast can use it.
      "60".enabled = false;
      "64".enabled = false;
      "65".enabled = false;
    };
  };

  system.primaryUser = username;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
