{ pkgs, ... }:
{
  imports = [
    ./colorscheme.nix
    ./completion.nix
    ./editor.nix
    ./lsp.nix
    ./options.nix
    ./telescope.nix
    ./treesitter.nix
    ./ui.nix
  ];

  extraPackages = with pkgs; [
    fd
    prettierd
    ripgrep
  ];
}
