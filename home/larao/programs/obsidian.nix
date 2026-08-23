{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.obsidian = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    package = null;

    vaults.notes.target = "Documents/Obsidian";

    defaultSettings.themes = [
      inputs.obsidian-extensions.legacyPackages.${pkgs.stdenv.hostPlatform.system}.obsidianThemes.tokyo-night
    ];
  };
}
