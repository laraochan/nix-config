{ lib, pkgs, ... }:
let
  wallpaper = builtins.path {
    path = ../../assets/wallpaper.png;
    name = "wallpaper.png";
  };
in
{
  programs.desktoppr = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    settings = {
      picture = wallpaper;
      scale = "fill";
    };
  };
}
