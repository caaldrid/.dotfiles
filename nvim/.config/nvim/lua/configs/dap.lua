local setup = function()
  local dap = require "dap"
  local get_python_path = require "helpers.python-path"

  dap.adapters.python = {
    type = "executable",
    command = get_python_path(vim.fn.getcwd()),
    args = { "-m", "debugpy.adapter" },
  }

  dap.configurations.python = {
    {
      -- The first three options are required by nvim-dap
      type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Launch file",

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = "${file}", -- This configuration will launch the current file if used.
      pythonPath = function()
        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
        return get_python_path(vim.fn.getcwd())
      end,
    },
  }
end

---@type NvPluginSpec
local spec = {
  "mfussenegger/nvim-dap",
  ft = { "go", "python" },
  config = function()
    setup()
  end,
}

return spec
