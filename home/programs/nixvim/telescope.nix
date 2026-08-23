{ ... }:
{
  plugins.telescope = {
    enable = true;
    extensions.fzf-native.enable = true;
    settings.defaults = {
      layout_config.prompt_position = "top";
      sorting_strategy = "ascending";
      path_display = [ "smart" ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files hidden=true<CR>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "Search help";
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>Telescope lsp_document_symbols<CR>";
      options.desc = "Document symbols";
    }
    {
      mode = "n";
      key = "<leader>fS";
      action = "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>";
      options.desc = "Workspace symbols";
    }
    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
      options.desc = "Search current buffer";
    }
  ];
}
