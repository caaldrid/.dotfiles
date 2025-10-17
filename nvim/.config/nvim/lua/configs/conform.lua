local spec = {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  event = "BufWritePre", -- uncomment for format on save
  --@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofumpt", "goimports-reviser", "golines" },
      sh = { "shellcheck", "shfmt" },
      python = { "isort", "black" },
      html = { "prettierd" },
      yaml = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      markdown = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },

    format_on_save = {
      timeout_ms = 1000,
    },
    formatters = {
      prettierd = {
        condition = function()
          return vim.loop.fs_realpath ".prettierrc.js" ~= nil or vim.loop.fs_realpath ".prettierrc.mjs" ~= nil
        end,
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}

return spec
