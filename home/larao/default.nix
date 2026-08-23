{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./programs/gh.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/yazi.nix
    ./programs/zsh.nix
  ];

  home.packages = with pkgs; [
    codex
    fd
    ripgrep
  ];

  home = {
    inherit username;
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    # Keep this value at the version used when Home Manager was introduced.
    stateVersion = "26.05";
  };
}
