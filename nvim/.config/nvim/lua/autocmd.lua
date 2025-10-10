vim.api.nvim_create_autocmd("FileType", {
  pattern = {
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
  },
  callback = function()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.treesitter.start()
  end,
})
