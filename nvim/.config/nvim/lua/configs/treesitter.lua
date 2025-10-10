local spec = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    ts = require "nvim-treesitter"
    ts.install({
      "vim",
      "lua",
      "vimdoc",
      "c_sharp",
      "go",
      "gomod",
      "bash",
      "markdown",
      "markdown_inline",
      "python",
      "javascript",
      "typescript",
      "dockerfile",
      "gitignore",
      "html",
      "css",
      "yaml",
      "json",
      "tsx",
    }):wait(300000)
  end,
}

return spec
