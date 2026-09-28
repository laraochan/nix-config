{ self, pkgs, ... }:

{
  nix.enable = false;

  system = {
    configurationRevision =
      self.rev or self.dirtyRev or null;

    stateVersion = 6;

    primaryUser = "larao";
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  users.users.larao = {
    name = "larao";
    home = "/Users/larao";
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  homebrew = {
    enable = true;

    # Also enables Homebrew's zsh initialization.
    enableZshIntegration = false;

    casks = [
      "google-chrome"
      "discord"
      "spotify"
    ];
  };
}
