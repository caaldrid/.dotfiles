dofile(vim.g.base46_cache .. "git")

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

---@type NvPluginSpec
local spec = {
  "lewis6991/gitsigns.nvim",
  event = "User FilePost",
  config = function(plugins, opts)
    setup(plugins, opts)
  end,
  keys = {
    {
      mode = "n",
      "<leader>gb",
      "<CMD> Gitsigns blame_line <cr>",
      desc = "Git Blame Line",
    },
    {
      mode = "n",
      "<leader>ph",
      "<CMD> Gitsigns preview_hunk <cr>",
      desc = "Preview Git Hunk",
    },
    {
      mode = "n",
      "<leader>gsh",
      "<CMD> Gitsigns stage_hunk <cr>",
      desc = "Stage Git Hunk",
    },
    {
      mode = "n",
      "<leader>rh",
      "<CMD> Gitsigns reset_hunk <cr>",
      desc = "Reset Git Hunk",
    },
    {
      mode = "n",
      "<leader>ush",
      "<CMD> Gitsigns undo_stage_hunk <cr>",
      desc = "Unstage Git Hunk",
    },
  },
}

return spec
