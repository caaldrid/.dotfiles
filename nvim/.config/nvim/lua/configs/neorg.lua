local setup = function()
  require("neorg").setup {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {
        config = {
          folds = true,
          icon_preset = "varied",
        },
      },
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/notes",
          },
          default_workspace = "notes",
        },
      },
      ["core.integrations.treesitter"] = {
        config = {
          configure_parsers = true,
          install_parsers = true,
        },
      },
      ["core.journal"] = {
        config = {
          strategy = "nested",
          workspace = "notes",
        },
      },
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.integrations.nvim-cmp"] = {},
    },
  }
end

local spec = {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    setup()
  end,
}

return spec
