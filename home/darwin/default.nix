{ pkgs, username, ... }:
{
  imports = [
    ./desktoppr.nix
    ./obsidian.nix
  ];

  home = {
    homeDirectory = "/Users/${username}";
    packages = [ pkgs._1password-cli ];
  };
}
