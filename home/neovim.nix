{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  # Nixvim owns Neovim, its plugins, and their configuration as one user
  # environment.
  programs.nixvim = {
    enable = true;
    imports = [ ./nixvim ];
  };
}
