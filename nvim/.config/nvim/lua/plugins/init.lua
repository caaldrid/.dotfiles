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
        "python",
      },
    },
  },

  ---@type NvPluginSpec
  { import = "configs.dap" },

  ---@type NvPluginSpec
  { import = "configs.gitsigns" },

  ---@type NvPluginSpec
  { import = "configs.git-fugitive" },

  ---@type NvPluginSpec
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  ---@type NvPluginSpec
  {
    "hrsh7th/nvim-cmp",
    config = function(_, opts)
      table.insert(opts.sources, { name = "neorg" })
      require("cmp").setup(opts)
    end,
    dependencies = {
      ---@type NvPluginSpec
      { import = "configs.neorg" },
    },
  },
}
