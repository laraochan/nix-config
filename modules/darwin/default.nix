{
  config,
  inputs,
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
    backupFileExtension = "hm-backup";
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
      "1password"
      "nani"
      "obsidian"
    ];
    onActivation = {
      autoUpdate = false;
      upgrade = false;
    };
  };

  system.defaults = {
    ".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;

    dock = {
      show-recents = false;
      persistent-apps = [
        { app = "/Applications/Google Chrome.app"; }
        { app = "/Applications/Ghostty.app"; }
        { app = "/Applications/Obsidian.app"; }
        { app = "/Applications/Discord.app"; }
        { app = "/Applications/Spotify.app"; }
        { app = "/Applications/1Password.app"; }
      ];
    };
  };

  system.primaryUser = username;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
