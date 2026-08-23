{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  # Nixvim is the explicit exception to the config-only Home Manager policy.
  # It owns Neovim, its plugins, and their configuration as one user environment.
  programs.nixvim = {
    enable = true;
    imports = [ ./nixvim ];
  };
}
