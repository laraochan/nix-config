{ pkgs, ... }: {
  home = {
    stateVersion = "26.05";
  
    packages = with pkgs; [
      ripgrep
      fzf
      bat
    ];
  };

  programs.git.enable = true;
  programs.gh.enable = true;
  programs.emacs.enable = true;
}

