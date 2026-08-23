{ lib, pkgs, ... }:
{
  programs.desktoppr = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    settings = {
      picture = ../../../assets/wallpaper.png;
      scale = "fill";
    };
  };
}
