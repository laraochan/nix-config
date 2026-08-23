{ pkgs, username, ... }:
let
  wallpaper = builtins.path {
    path = ../../assets/wallpaper.png;
    name = "wallpaper.png";
  };
in
{
  home = {
    homeDirectory = "/home/${username}";
    packages = [ pkgs.wget ];
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file://${wallpaper}";
      picture-uri-dark = "file://${wallpaper}";
    };

    "org/gnome/desktop/input-sources".xkb-options = [ "ctrl:nocaps" ];

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.kimpanel.extensionUuid
      ];
      favorite-apps = [
        "firefox.desktop"
        "com.mitchellh.ghostty.desktop"
        "obsidian.desktop"
        "spotify.desktop"
        "1password.desktop"
      ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
