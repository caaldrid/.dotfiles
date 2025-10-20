local map = vim.keymap.set

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
map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug Toggle Breakpoint" })

map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug Continue" })

map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Debug Step Into" })

map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Debug Step Over" })

map("n", "<F23>", function()
  require("dap").step_out()
end, { desc = "Debug Step Out" })

map("n", "<F17>", function()
  require("dap").terminate()
  require("dapui").close()
  require("nvim-dap-virtual-text").toggle()
end, { desc = "Debug Terminate" })

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
  local neotest = require "neotest"
  local ft = vim.bo.filetype
  local testfile = vim.fn.expand "%"
  if ft == "python" then
    testfile = string.format("%s_test.py", vim.fn.expand "%:r")
  end
  if ft == "go" then
    testfile = string.format("%s_test.go", vim.fn.expand "%:r")
  end

  neotest.run.run { testfile, strategy = "integrated", suite = true }
end, { desc = "Test Run File" })
map("n", "<leader>td", function()
  local neotest = require "neotest"
  local ft = vim.bo.filetype
  local testfile = vim.fn.expand "%"
  if ft == "python" then
    testfile = string.format("%s_test.py", vim.fn.expand "%:r")
  end
  if ft == "go" then
    testfile = string.format("%s_test.go", vim.fn.expand "%:r")
  end

  neotest.run.run { testfile, strategy = "dap", suite = true }
end, { desc = "Test Run in Debug" })
map("n", "<leader>tw", function()
  require("neotest").watch.watch()
end, { desc = "Test Watch" })

--Opencode
map({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Opencode Ask about this" })
map({ "n", "x" }, "<leader>o+", function()
  require("opencode").prompt "@this"
end, { desc = "Opencode Add this" })
map({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Opencode Select prompt" })
map("n", "<leader>ot", function()
  require("opencode").toggle()
end, { desc = "Opencode Toggle embedded" })
map("n", "<leader>on", function()
  require("opencode").command "session_new"
end, { desc = "Opencode New session" })
map("n", "<leader>oi", function()
  require("opencode").command "session_interrupt"
end, { desc = "Opencode Interrupt session" })
map("n", "<leader>oA", function()
  require("opencode").command "agent_cycle"
end, { desc = "Opencode Cycle selected agent" })
map("n", "<S-C-u>", function()
  require("opencode").command "messages_half_page_up"
end, { desc = "Opencode Messages half page up" })
map("n", "<S-C-d>", function()
  require("opencode").command "messages_half_page_down"
end, { desc = "Messages half page down" })

--Tabby
map("n", "<leader>mtl", function()
  local tabpages = vim.api.nvim_list_tabpages()
  if #tabpages < 2 then
    vim.notify("Only one tab is open — nothing to move.", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify("Invalid buffer number.", vim.log.levels.ERROR)
    return
  end

  local tabnr = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
  if tabnr < 1 then
    vim.notify("This is the left most tab.", vim.log.levels.WARN)
    return
  end

  -- Go to destination tab
  vim.cmd("tabnext " .. tabnr - 1)
  -- Open the buffer as a vertical split
  vim.cmd("botright vert sbuffer " .. bufnr)

  -- Return to the source tab
  vim.cmd("tabnext " .. tabnr)
  vim.cmd "close"

  -- Go to destination tab
  vim.cmd("tabnext " .. tabnr - 1)
end, { desc = "Tab Move buffer to left tab" })

map("n", "<leader>mtr", function()
  local tabpages = vim.api.nvim_list_tabpages()
  if #tabpages < 2 then
    vim.notify("Only one tab is open — nothing to move.", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify("Invalid buffer number.", vim.log.levels.ERROR)
    return
  end

  local tabnr = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
  if tabnr == #tabpages then
    vim.notify("This is the right most tab.", vim.log.levels.WARN)
    return
  end

  -- Go to destination tab
  vim.cmd("tabnext " .. tabnr + 1)
  -- Open the buffer as a vertical split
  vim.cmd("botright vert sbuffer " .. bufnr)

  -- Return to the source tab
  vim.cmd("tabnext " .. tabnr)
  vim.cmd "close"

  -- Go to destination tab
  vim.cmd("tabnext " .. tabnr + 1)
end, { desc = "Tab Move buffer to right tab" })
