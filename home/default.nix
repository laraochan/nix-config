{
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./programs/desktoppr.nix
    ./programs/gh.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/lazygit.nix
    ./programs/neovim.nix
    ./programs/obsidian.nix
    ./programs/yazi.nix
    ./programs/zsh.nix
  ];

  home.packages =
    with pkgs;
    [
      codex
      fd
      ripgrep
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wget ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ _1password-cli ];

  home = {
    inherit username;
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    # Keep this value at the version used when Home Manager was introduced.
    stateVersion = "26.05";
  };

  dconf.settings = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "org/gnome/desktop/input-sources".xkb-options = [ "ctrl:nocaps" ];
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
    "org/gnome/shell".enabled-extensions = [
      pkgs.gnomeExtensions.kimpanel.extensionUuid
    ];
  };

  xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
