local specs = {
  ---@type NvPluginSpec
  {
    "mfussenegger/nvim-dap",
  },
  ---@type NvPluginSpec
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      -- Configure dap-go with the Mason installed DAP
      require("dap-go").setup {
        delve = {
          path = vim.fn.stdpath "data" .. "/mason/bin/dlv",
        },
      }
    end,
  },
  ---@type NvPluginSpec
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local get_python_path = require "helpers.python-path"
      require("dap-python").setup(get_python_path(vim.fn.getcwd()))
    end,
  },
  ---@type NvPluginSpec
  {
    "rcarriga/nvim-dap-ui",
    ft = { "go", "python" },
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dapui.setup()

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      ---@diagnostic disable-next-line: undefined-field
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "nvim-neotest/nvim-nio" },
    },
  },
}

return specs
