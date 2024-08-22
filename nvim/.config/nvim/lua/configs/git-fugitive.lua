---@type NvPluginSpec
local spec = {
  "tpope/vim-fugitive",
  cmd = { "Git", "G" },
  keys = {
    {
      mode = "n",
      "<leader>gP",
      "<CMD> G pull '--rebase' <cr>",
      desc = "Git Pull",
    },
    {
      mode = "n",
      "<leader>gp",
      "<CMD> G push <cr>",
      desc = "Git Push",
    },
  },
}

return spec
