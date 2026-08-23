{ ... }:
let
  wallpaper = builtins.path {
    path = ../../assets/wallpaper.png;
    name = "wallpaper.png";
  };
in
{
  programs.desktoppr = {
    enable = true;
    settings = {
      picture = wallpaper;
      scale = "fill";
    };
  };
}
