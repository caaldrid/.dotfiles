local setup = function() end

---@type NvPluginSpec
local spec = {
  "mfussenegger/nvim-dap",
  config = function()
    setup()
  end,
  keys = {
    {
      mode = "n",
      "<leader>dtb",
      "<CMD> DapToggleBreakpoint <CR>",
      desc = "Toggle diagnostics",
    },
    {
      mode = "n",
      "<leader>dus",
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      desc = "Open debugging sidebar",
    },
  },
}

return spec
