local setup = function() end

---@type NvPluginSpec
local spec = {
  "mfussenegger/nvim-dap",
  config = function()
    setup()
  end,
}

return spec
