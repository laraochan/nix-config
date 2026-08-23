{
  homePlatform,
  pkgs,
  username,
  ...
}:
let
  platformModule =
    if homePlatform == "darwin" then
      ./darwin
    else if homePlatform == "nixos" then
      ./nixos
    else
      throw "Unsupported Home Manager platform: ${homePlatform}";
in
{
  imports = [
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./yazi.nix
    ./zsh.nix
    platformModule
  ];

  home = {
    inherit username;
    packages = with pkgs; [
      codex
      fd
      ripgrep
    ];
    # Keep this value at the version used when Home Manager was introduced.
    stateVersion = "26.05";
  };
}
