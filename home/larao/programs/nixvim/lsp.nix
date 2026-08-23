{ lib, ... }:
{
  plugins.lspconfig.enable = true;

  lsp.servers = {
    gopls.enable = true;
    nil_ls.enable = true;
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

  extraConfigLua = ''
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = true,
      virtual_text = { spacing = 2, source = "if_many" },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local map = function(keys, action, description)
          vim.keymap.set("n", keys, action, {
            buffer = args.buf,
            desc = "LSP: " .. description,
          })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", vim.lsp.buf.references, "List references")
        map("gI", vim.lsp.buf.implementation, "Go to implementation")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
      end,
    })
  '';
}
