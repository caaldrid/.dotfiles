return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- Set up LSP stuff
  { import = "configs.lspconfig" },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = { custom = { "^\\.git$", "__pycache__", "\\.pyc$" } },
      renderer = {
        highlight_git = "icon",
        icons = {
          git_placement = "signcolumn",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            folder = { default = "", open = "" },
            git = { unstaged = "✗", staged = "✓", unmerged = "", renamed = "➜", untracked = "★" },
          },
        },
      },
      git = { enable = true, show_on_dirs = true, show_on_open_dirs = true },
      view = {
        adaptive_size = true,
        side = "left",
        preserve_window_proportions = true,
      },
    },
  },

  { import = "configs.treesitter" },

  { "lewis6991/gitsigns.nvim" },

  { import = "configs.git-fugitive" },

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

  { import = "configs.dap" },

  { import = "configs.typescript-tools" },
  { import = "configs.blink-completion" },
  {
    "cpea2506/one_monokai.nvim",
    config = function(_, opts)
      require("one_monokai").setup {
        transparent = true,
      } -- calling setup is optional
      vim.cmd [[colorscheme one_monokai]]
    end,
  },
  { import = "configs.neotest" },
  { import = "configs.opencode" },
}
