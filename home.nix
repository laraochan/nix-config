{ config, pkgs, inputs, ... }:
let
  tangle = inputs.org-babel.lib.tangleOrgBabel { languages = [ "emacs-lisp" ]; };
in
{
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

  programs.vesktop.enable = true;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
      userSettings = {
        "security.workspace.trust.enabled" = true;
        "nix.enableLanguageServer" = true;

      };
    };
  };

  programs.codex = {
    enable = true;
  };

  programs.opencode = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages =
      epkgs: with epkgs; [
        panda-theme
      ];
  };
  home.file.".emacs.d/init.el".text = tangle (builtins.readFile ./config/emacs/init.org);
  home.file.".emacs.d/early-init.el".text = tangle (builtins.readFile ./config/emacs/early-init.org);

  home.packages = with pkgs; [
    nixd
    nixfmt
  ];

  home.stateVersion = "26.05";
}
