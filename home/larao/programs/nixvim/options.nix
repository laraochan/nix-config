{ ... }:
{
  globals.mapleader = " ";
  globals.maplocalleader = " ";

  opts = {
    number = true;
    relativenumber = true;
    cursorline = true;
    signcolumn = "yes";
    termguicolors = true;

    # Editing defaults.
    expandtab = true;
    shiftwidth = 2;
    softtabstop = 2;
    tabstop = 2;
    smartindent = true;
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;

    # Search and completion.
    ignorecase = true;
    smartcase = true;
    completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];

    # Keep undo history across sessions and react quickly to diagnostics.
    undofile = true;
    updatetime = 250;
    timeoutlen = 400;
    splitbelow = true;
    splitright = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>write<CR>";
      options.desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>confirm quit<CR>";
      options.desc = "Quit window";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Focus lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Focus upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Focus right window";
    }
  ];
}
