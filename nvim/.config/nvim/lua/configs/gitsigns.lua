local setup = function(_, _)
  require("gitsigns").setup {
    signs = {
      delete = { text = "󰍵" },
      changedelete = { text = "󱕖" },
      untracked = { text = "󰎔" },
    },
    signs_staged = {
      add = { text = "+┃" },
      change = { text = "*┃" },
      delete = { text = "-󰍵" },
      topdelete = { text = "*‾" },
      changedelete = { text = "-󱕖" },
      untracked = { text = "*󰎔" },
    },
  }
end

local spec = {
  "lewis6991/gitsigns.nvim",
  event = "User FilePost",
  config = function(plugins, opts)
    setup(plugins, opts)
  end,
}

return spec
