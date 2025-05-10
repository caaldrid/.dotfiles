local specs = {
  ---@type NvPluginSpec
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  ---@type NvPluginSpec
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  ---@type NvPluginSpec
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = { "delve", "python" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      }
    end,
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

      vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

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
  },
}

return specs
