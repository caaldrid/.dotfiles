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
  },
}

return spec
