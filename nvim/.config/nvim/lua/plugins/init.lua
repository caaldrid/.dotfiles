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
  { import = "configs.dap-go" },

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
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    ft = { "go", "python" },
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dapui.setup()

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
