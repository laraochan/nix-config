{ ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap.preset = "default";
      appearance.nerd_font_variant = "mono";
      completion = {
        documentation.auto_show = true;
        ghost_text.enabled = true;
        menu.draw.treesitter = [ "lsp" ];
      };
      signature.enabled = true;
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
    };
  };

  plugins.luasnip.enable = true;
}
