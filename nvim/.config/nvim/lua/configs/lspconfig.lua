local setup = function(_, opts)
  require("mason").setup(opts)
  require "mason-core.package"

  local nvlsp = require "nvchad.configs.lspconfig"
  -- Make sure lsp picks up newly added files
  nvlsp.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

  -- This will setup lsp for servers you listed above
  -- And servers you install through mason UI
  -- So defining servers in the list above is optional
  require("mason-lspconfig").setup {
    ensure_installed = { "gopls", "lua_ls", "bashls", "pyright", "ts_ls", "eslint" },
  }

  -- configuring gopls lsp
  vim.lsp.config("gopls", {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })

  vim.lsp.config("pyright", {
    on_attach = nvlsp.on_attach,
    before_init = function(_, config)
      local get_python_path = require "helpers.python-path"
      config.settings.python.pythonPath = get_python_path(vim.fn.getcwd())
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })

  vim.lsp.config("eslint", {
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
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
