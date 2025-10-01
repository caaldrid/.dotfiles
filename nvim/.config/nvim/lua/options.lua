local o = vim.o
-- local g = vim.g

o.relativenumber = true

-- Hide the end of buffer lines that were showing a tilda character before
vim.wo.fillchars = "eob: "

-- Auto create folds using nvim-treesitter
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldenable = false
