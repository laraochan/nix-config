{ lib, ... }:
{
  plugins.lspconfig.enable = true;

  lsp.servers = {
    gopls.enable = true;
    rust_analyzer.enable = true;
    ts_ls.enable = true;
    lua_ls = {
      enable = true;
      config = {
        on_init = lib.nixvim.mkRaw ''
          function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json")
                  or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend(
              "force",
              client.config.settings.Lua,
              {
                runtime = {
                  version = "LuaJIT",
                  path = { "lua/?.lua", "lua/?/init.lua" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                  },
                },
              }
            )
          end
        '';
        settings.Lua = { };
      };
    };
  };

  # Preserve Neovim native completion from the previous configuration.
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, args.buf, {
            autotrigger = true,
          })
        end
      end,
    })
  '';
}
