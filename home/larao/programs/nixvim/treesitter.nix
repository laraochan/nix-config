{ config, ... }:
{
  plugins.treesitter = {
    enable = true;
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      astro
      css
      go
      html
      javascript
      json
      lua
      rust
      toml
      tsx
      typescript
    ];
  };

  # Keep the per-language indentation behavior from the previous Lua config.
  extraConfigLua = ''
    local languages = {
      lua = { indent = 4 },
      rust = { indent = 4 },
      toml = { indent = 4 },
      go = { indent = 4, tabstop = 8, expandtab = false },
      javascript = { indent = 2 },
      javascriptreact = { indent = 2 },
      typescript = { indent = 2 },
      typescriptreact = { indent = 2 },
      html = { indent = 2 },
      css = { indent = 2 },
      json = { indent = 2 },
      astro = { indent = 2 },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.tbl_keys(languages),
      callback = function(ev)
        local language = languages[vim.bo[ev.buf].filetype]
        vim.treesitter.start(ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.bo[ev.buf].tabstop = language.tabstop or language.indent
        vim.bo[ev.buf].shiftwidth = language.indent
        vim.bo[ev.buf].softtabstop = language.indent
        vim.bo[ev.buf].expandtab = language.expandtab ~= false
      end,
    })
  '';
}
