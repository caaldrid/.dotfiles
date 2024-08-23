local setup = function()
  -- Configure dap-go with the Mason installed DAP
  require("dap-go").setup {
    delve = {
      path = vim.fn.stdpath "data" .. "/mason/bin/dlv",
    },
  }
end

---@type NvPluginSpec
local spec = {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = "mfussenegger/nvim-dap",
  config = function()
    setup()
  end,
}

return spec
