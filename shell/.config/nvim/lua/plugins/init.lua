return {
  -- Set up LSP stuff
  ---@type NvPluginSpec
  { import = "configs.lspconfig" },

  ---@type NvPluginSpec
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  ---@type NvPluginSpec
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = { dotfiles = false, custom = { "^\\.git$" } },
    },
  },

  ---@type NvPluginSpec
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "c_sharp",
        "go",
        "gomod",
        "bash",
        "markdown",
        "markdown_inline",
      },
    },
  },

  ---@type NvPluginSpec
  { import = "configs.dap" },

  ---@type NvPluginSpec
  { import = "configs.dap-go" },

  ---@type NvPluginSpec
  { import = "configs.gitsigns" },
}
