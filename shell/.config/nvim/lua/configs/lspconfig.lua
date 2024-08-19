local nvlsp = require "nvchad.configs.lspconfig"

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

local setup = function(_, opts)
  require("mason").setup(opts)
  require "mason-core.package"

  local lspservers = { "gopls" }
  require("mason-lspconfig").setup {
    ensure_installed = lspservers,
  }

  -- This will setup lsp for servers you listed above
  -- And servers you install through mason UI
  -- So defining servers in the list above is optional
  require("mason-lspconfig").setup_handlers {
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
    -- TODO: Add mason-null-ls? mason-dap?
  },
}

return spec
