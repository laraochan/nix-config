{ ... }:
{
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidget.command = "fd --type f --hidden --follow --exclude .git";
      changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
      defaultOptions = [
        "--border=rounded"
        "--height=60%"
        "--layout=reverse"
      ];
      colors = {
        "bg+" = "#292e42";
        bg = "#1a1b26";
        spinner = "#bb9af7";
        hl = "#7aa2f7";
        fg = "#c0caf5";
        header = "#7dcfff";
        info = "#7aa2f7";
        pointer = "#bb9af7";
        marker = "#9ece6a";
        "fg+" = "#c0caf5";
        prompt = "#7dcfff";
        "hl+" = "#7aa2f7";
        border = "#565f89";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      presets = [ "tokyo-night" ];
    };
  };
}
