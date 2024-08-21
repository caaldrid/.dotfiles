---@type NvPluginSpec
local spec = {
  "tpope/vim-fugitive",
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
      "<CMD> G push",
      desc = "Git Push",
    },
  },
}

return spec
