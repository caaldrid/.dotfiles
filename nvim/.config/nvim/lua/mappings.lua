local map = vim.keymap.set
local nomap = vim.keymap.del

-- General Mappings
map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-v>", '<CMD> :execute "normal! \\<C-v>" <cr>', { desc = "Visual Block mode" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Telescope pick hidden term" })
map("n", "<leader>ff", function()
  local builtin = require "telescope.builtin"
  builtin.find_files { hidden = true }
end, { desc = "Telescope find files" })

-- Mappings for gitsigns
map("n", "<leader>gb", "<CMD> Gitsigns blame_line <cr>", { desc = "Git Blame Line" })
map("n", "<leader>gh", "<CMD> Gitsigns preview_hunk <cr>", { desc = "Git Preview Hunk" })
map("n", "<leader>gs", "<CMD> Gitsigns stage_hunk <cr>", { desc = "Git Stage Hunk" })
map("n", "<leader>gr", "<CMD> Gitsigns reset_hunk <cr>", { desc = "Git Reset Hunk" })
map("n", "<leader>gu", "<CMD> Gitsigns undo_stage_hunk <cr>", { desc = "Git Unstage Hunk" })

-- Mappings for fugitive
map("n", "<leader>gP", "<CMD> G pull '--rebase' <cr>", { desc = "Git Pull" })
map("n", "<leader>gp", "<CMD> G push <cr>", { desc = "Git Push" })
map("n", "<leader>gc", "<CMD> G commit <cr>", { desc = "Git Commit" })

-- Mappings for Dap
map("n", "<leader>dt", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug Toggle Breakpoint" })

map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Debug Continue" })

map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug Step Into" })

map("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Debug Step Over" })

map("n", "<leader>du", function()
  require("dap").step_out()
end, { desc = "Debug Step Out" })

map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "Debug Open REPL" })

map("n", "<leader>dl", function()
  require("dap").run_last()
end, { desc = "Debug Run Last" })

map("n", "<leader>dq", function()
  require("dap").terminate()
  require("dapui").close()
  require("nvim-dap-virtual-text").toggle()
end, { desc = "Debug Terminate" })

map("n", "<leader>db", function()
  require("dap").list_breakpoints()
end, { desc = "Debug List Breakpoints" })

map("n", "<leader>de", function()
  require("dap").set_exception_breakpoints { "all" }
end, { desc = "Debug Set Exception Breakpoints" })

-- Mappings for dap-go
-- map("n", "<leader>dgt", function()
--   require("dap-go").debug_test()
-- end, { desc = "Debug go test" })
--
-- map("n", "<leader>dgl", function()
--   require("dap-go").debug_last_test()
-- end, { desc = "Debug last go test" })

-- whichkey
map("n", "<leader>wk", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- neotest
map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Test Open Summary" })
map("n", "<leader>to", function()
  require("neotest").output_panel.toggle()
end, { desc = "Test Open Output" })
map("n", "<leader>tr", function()
  local nt = require "neotest"
  nt.output_panel.open()
  nt.run.run(vim.fn.expand "%")
end, { desc = "Test Run File" })
