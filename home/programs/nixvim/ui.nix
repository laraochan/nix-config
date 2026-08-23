{ ... }:
{
  plugins = {
    bufferline.enable = true;
    indent-blankline.enable = true;
    lualine.enable = true;
    web-devicons.enable = true;
    which-key.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>bh";
      action = "<cmd>BufferLineMovePrev<CR>";
      options.desc = "Move buffer left";
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>BufferLineMoveNext<CR>";
      options.desc = "Move buffer right";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLinePick<CR>";
      options.desc = "Pick buffer";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<CR>";
      options.desc = "Delete buffer";
    }
  ];
}
