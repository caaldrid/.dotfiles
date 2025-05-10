require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-v>", '<CMD> :execute "normal! \\<C-v>" <cr>', { desc = "Visual Block mode" })
-- Overwrite defaults from nvchad
nomap("n", "<leader>fa")
map(
  "n",
  "<leader>ff",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find files" }
)

-- Mappings for gitsigns
map("n", "<leader>gb", "<CMD> Gitsigns blame_line <cr>", { desc = "Git Blame Line" })
map("n", "<leader>gp", "<CMD> Gitsigns preview_hunk <cr>", { desc = "Preview Git Hunk" })
map("n", "<leader>gs", "<CMD> Gitsigns stage_hunk <cr>", { desc = "Stage Git Hunk" })
map("n", "<leader>gr", "<CMD> Gitsigns reset_hunk <cr>", { desc = "Reset Git Hunk" })
map("n", "<leader>gsu", "<CMD> Gitsigns undo_stage_hunk <cr>", { desc = "Unstage Git Hunk" })

-- Mappings for fugitive
map("n", "<leader>gP", "<CMD> G pull '--rebase' <cr>", { desc = "Git Pull" })
map("n", "<leader>gp", "<CMD> G push <cr>", { desc = "Git Push" })

-- Mappings for Dap
map("n", "<leader>dt", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Continue" })

map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step Into" })

map("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Step Over" })

map("n", "<leader>du", function()
  require("dap").step_out()
end, { desc = "Step Out" })

map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "Open REPL" })

map("n", "<leader>dl", function()
  require("dap").run_last()
end, { desc = "Run Last" })

map("n", "<leader>dq", function()
  require("dap").terminate()
  require("dapui").close()
  require("nvim-dap-virtual-text").toggle()
end, { desc = "Terminate" })

map("n", "<leader>db", function()
  require("dap").list_breakpoints()
end, { desc = "List Breakpoints" })

map("n", "<leader>de", function()
  require("dap").set_exception_breakpoints { "all" }
end, { desc = "Set Exception Breakpoints" })

-- Mappings for dap-go
map("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })

map("n", "<leader>dgl", function()
  require("dap-go").debug_last_test()
end, { desc = "Debug last go test" })
