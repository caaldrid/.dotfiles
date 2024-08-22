-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

local setup = function(_, opts)
  require("mason").setup(opts)
  require "mason-core.package"

  local lspservers = { "gopls", "lua_ls", "bashls" }
  require("mason-lspconfig").setup {
    ensure_installed = lspservers,
  }

  -- This will setup lsp for servers you listed above
  -- And servers you install through mason UI
  -- So defining servers in the list above is optional
  require("mason-lspconfig").setup_handlers {
    -- Default setup for all servers, unless a custom one is defined below
    function(server_name)
      lspconfig[server_name].setup {
        on_attach = function(client, bufnr)
          nvlsp.on_attach(client, bufnr)
          -- Add your other things here
          -- Example being format on save or something
        end,
        capabilities = nvlsp.capabilities,
        on_init = nvlsp.on_init,
      }
    end,
    -- configuring gopls lsp
    ["gopls"] = function()
      lspconfig.gopls.setup {
        cmd = { "gopls" },
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              deprecated = true,
            },
            staticcheck = true,
          },
        },
      }
    end,

    -- Here, we disable lua_ls so we can use NvChad's default config
    ["lua_ls"] = function() end,
  }
end

---@type NvPluginSpec
local spec = {
  "neovim/nvim-lspconfig",
  -- BufRead is to make sure if you do nvim some_file then this is still going to be loaded
  event = { "VeryLazy", "BufRead" },
  config = function() end, -- Override to make sure load order is correct
  dependencies = {
    {
      "williamboman/mason.nvim",
      cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
      config = function(plugin, opts)
        setup(plugin, opts)
      end,
    },
    "williamboman/mason-lspconfig",
  },
}

return spec
