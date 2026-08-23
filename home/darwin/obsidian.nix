{
  inputs,
  pkgs,
  ...
}:
{
  programs.obsidian = {
    enable = true;
    package = null;

    vaults.notes.target = "Documents/Obsidian";

    defaultSettings.appearance.theme = "obsidian";
    defaultSettings.themes = [
      inputs.obsidian-extensions.legacyPackages.${pkgs.stdenv.hostPlatform.system}.obsidianThemes.tokyo-night
    ];
  };
}
