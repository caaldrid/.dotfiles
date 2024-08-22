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
  "dreamsofcode-io/nvim-dap-go",
  ft = "go",
  dependencies = "mfussenegger/nvim-dap",
  config = function()
    setup()
  end,
  keys = {
    {
      mode = "n",
      "<leader>dgt",
      function()
        require("dap-go").debug_test()
      end,
      desc = "Debug go test",
    },
    {
      mode = "n",
      "<leader>dgl",
      function()
        require("dap-go").debug_last_test()
      end,
      desc = "Debug last go test",
    },
  },
}

return spec
