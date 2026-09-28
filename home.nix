{ pkgs, inputs, ... }:

{
  home = {
    username = "larao";
    homeDirectory = "/Users/larao";

    stateVersion = "26.05";

    packages = with pkgs; [
      ripgrep
      fd
      fzf
      jq
    ];
  };

  programs.home-manager.enable = true;

  programs.zsh.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "laraochan";
        email = "me@larao.dev";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gh.enable = true;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
      userSettings = {
        "settingsSync.enabled" = false;
        "security.workspace.trust.enabled" = true;
        "workbench.startupEditor" = "none";

        # Do not use VS Code's GitHub authentication
        "git.githubAuthentication" = false;
        "git.terminalAuthentication" = false;

        "telemetry.telemetryLevel" = "off";
        "nix.enableLanguageServer" = true;
        "chat.disableAIFeatures" = true;
        "update.mode" = "none";
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;
      };
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages =
      epkgs: with epkgs; [
      ];
  };
  home.file.".emacs.d/init.el".text =
    inputs.org-babel.lib.tangleOrgBabel {
      languages = [ "emacs-lisp" ];
    } (builtins.readFile ./config/emacs/init.org);
  
  home.file.".emacs.d/early-init.el".text =
    inputs.org-babel.lib.tangleOrgBabel {
      languages = [ "emacs-lisp" ];
    } (builtins.readFile ./config/emacs/early-init.org);

  programs.opencode = {
    enable = true;
  };
}
