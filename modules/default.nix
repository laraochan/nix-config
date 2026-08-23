{
  pkgs,
  systemPlatform,
  ...
}:
let
  platformModule =
    if systemPlatform == "darwin" then
      ./darwin
    else if systemPlatform == "nixos" then
      ./nixos
    else
      throw "Unsupported system platform: ${systemPlatform}";
in
{
  imports = [ platformModule ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.zsh.enable = true;
}
