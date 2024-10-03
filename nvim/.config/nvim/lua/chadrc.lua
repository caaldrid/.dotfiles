-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "dark_horizon",
  transparency = true,
}

M.ui = {
  statusline = {
    theme = "default",
    modules = {
      cursor = function()
        return "%#StText# Ln %l, Col %c  "
      end,
    },
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd" },
  },
  telescope = { style = "bordered" },
  tabufline = {
    order = { "treeOffset", "buffers", "tabs" },
  },
}

M.nvdash = {
  load_on_startup = true,

  buttons = {
    { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files no_ignore=true hidden=true" },
    { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "Spc t h", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashLazy",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
  },
}

M.mason = { pkgs = { "delve" } }

return M
