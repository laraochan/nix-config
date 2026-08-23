{ ... }:
{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 1000;
        };
        formatters_by_ft = {
          go = [ "gofmt" ];
          javascript = [
            "prettierd"
            "prettier"
          ];
          javascriptreact = [
            "prettierd"
            "prettier"
          ];
          json = [
            "prettierd"
            "prettier"
          ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          rust = [ "rustfmt" ];
          typescript = [
            "prettierd"
            "prettier"
          ];
          typescriptreact = [
            "prettierd"
            "prettier"
          ];
        };
      };
    };

    gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        filesystem.follow_current_file.enabled = true;
      };
    };

    todo-comments.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle reveal<CR>";
      options.desc = "Toggle file explorer";
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = ''<cmd>lua require("conform").format({ async = true, lsp_format = "fallback" })<CR>'';
      options.desc = "Format buffer";
    }
    {
      mode = "n";
      key = "<leader>cF";
      action = "<cmd>ConformInfo<CR>";
      options.desc = "Formatter information";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Gitsigns blame_line<CR>";
      options.desc = "Git blame line";
    }
  ];
}
