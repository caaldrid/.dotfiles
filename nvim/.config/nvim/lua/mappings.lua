require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Overwrite defaults from nvchad
nomap("n", "<leader>fa")
map(
  "n",
  "<leader>ff",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find files" }
)

-- Mappings for dap plugin
map("n", "<leader>dtb", "<CMD> DapToggleBreakpoint <CR>", { desc = "Toggle diagnostics" })
map("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })

-- Mappings for dap-go
map("n", "<leader>dgt", function()
  ---@diagnostic disable-next-line: undefined-field
  require("dap-go").debug_test()
end, { desc = "Debug go test" })
map("n", "<leader>dgl", function()
  ---@diagnostic disable-next-line: undefined-field
  require("dap-go").debug_last_test()
end, { desc = "Debug last go test" })

-- Mappings for gitsigns
map("n", "<leader>gb", "<CMD> Gitsigns blame_line <cr>", { desc = "Git Blame Line" })
map("n", "<leader>ph", "<CMD> Gitsigns preview_hunk <cr>", { desc = "Preview Git Hunk" })
map("n", "<leader>gsh", "<CMD> Gitsigns stage_hunk <cr>", { desc = "Stage Git Hunk" })
map("n", "<leader>rh", "<CMD> Gitsigns reset_hunk <cr>", { desc = "Reset Git Hunk" })
map("n", "<leader>ush", "<CMD> Gitsigns undo_stage_hunk <cr>", { desc = "Unstage Git Hunk" })

-- Mappings for fugitive
map("n", "<leader>gP", "<CMD> G pull '--rebase' <cr>", { desc = "Git Pull" })
map("n", "<leader>gp", "<CMD> G push <cr>", { desc = "Git Push" })
