local spec = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python", -- Python Tests adapter
    { "fredrikaverpil/neotest-golang", version = "*" }, -- Go Tests adapter
  },
  lazy = true,
  ft = { "go", "python" },
  config = function()
    local get_python_path = require "helpers.python-path"

    local neotest_python_opts = {
      python = get_python_path(vim.fn.getcwd()),
      runner = function()
        local handle = io.popen "pytest --version"
        if handle ~= nil then
          local result = handle:read "*a"
          handle:close()
          if string.len(result) ~= 0 then
            return "pytest"
          else
            return "unittest"
          end
        end
      end,
    }
    local neotest_golang_opts = {}

    local nt = require "neotest"
    local ntp = require "neotest-python"(neotest_python_opts)
    local ntg = require "neotest-golang"(neotest_golang_opts)

    nt.setup {
      adapters = { ntp, ntg },
    }
  end,
}

return spec
