local setup = function()
  -- Map keys
  local map = vim.keymap.set

  map("n", "<leader>dgt", function()
    require("dap-go").debug_test()
  end, { desc = "Debug test" })

  map("n", "<leader>dgl", function()
    require("dap-go").debug_last_test()
  end, { desc = "Debug last go test" })

  -- Configure dap-go with the Mason installed DAP
  require("dap-go").setup {
    delve = {
      path = vim.fn.stdpath "data" .. "/mason/bin/dlv",
    },
  }
end

---@type NvPluginSpec
local spec = {
  "dreamsofcode-io/nvim-dap-go",
  ft = "go",
  dependencies = "mfussenegger/nvim-dap",
  config = function()
    setup()
  end,
}

return spec
