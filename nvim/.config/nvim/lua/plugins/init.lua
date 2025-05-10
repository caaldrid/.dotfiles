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
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup {
        pickers = {
          live_grep = {
            additional_args = function(opts)
              return { "--hidden" }
            end,
          },
        },
      }
    end,
  },

  ---@type NvPluginSpec
  { import = "configs.dap" },
}
