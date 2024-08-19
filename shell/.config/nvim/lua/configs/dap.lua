local setup = function()
  -- Set up key mappping
  local map = vim.keymap.set

  map("n", "<leader>dtb", "<CMD> DapToggleBreakpoint <CR>", { desc = "Toggle diagnostics" })

  map("n", "<leader>dus", function()
    local widgets = require "dap.ui.widgets"
    local sidebar = widgets.sidebar(widgets.scopes)
    sidebar.open()
  end, { desc = "Open debugging sidebar" })
end

---@type NvPluginSpec
local spec = {
  "mfussenegger/nvim-dap",
  config = function()
    setup()
  end,
}

return spec
