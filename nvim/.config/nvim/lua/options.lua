
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus'

-- turn on hybrid line numbering
vim.o.relativenumber = true
vim.o.number = true

--vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='grey' })

vim.o.signcolumn = 'yes'

vim.o.tabstop = 8
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.softtabstop=0

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = 'a'

vim.opt.pumheight = 5 -- limit completion items
---            Mappings
---------------------------------------------

vim.api.nvim_set_keymap('v', '<leader>(', 'c()<Esc>P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>[', 'c[]<Esc>P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>{', 'c{}<Esc>P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>\"', 'c\"\"<Esc>P', { noremap = true, silent = true })

---- Start and end of the line (non-whitespace) ----
-- Normal mode mappings
vim.keymap.set('n', '<C-s>', '^', { desc = "Move to start of non-whitespace" })
vim.keymap.set('n', '<C-l>', '$', { desc = "Move to end of line" })

-- Optional: Visual mode mappings (useful for selecting)
vim.keymap.set('v', '<C-s>', '^', { desc = "Move to start of non-whitespace (Visual)" })
vim.keymap.set('v', '<C-l>', '$', { desc = "Move to end of line (Visual)" })

-- Optional: Operator-pending mode mappings (e.g., for 'd<C-k>')
-- This allows you to combine it with operators like d (delete), y (yank), c (change)
vim.keymap.set('o', '<C-s>', '^', { desc = "Move to start of non-whitespace (Operator)" })
vim.keymap.set('o', '<C-l>', '$', { desc = "Move to end of line (Operator)" })

-- ctrl+h == ctrl+backspace in older terminals for historic reasons
vim.keymap.set('i', '<C-h>', '<C-w>', { desc = "Remove a word" })
-- turn off diagnostics by default
local config = vim.diagnostic.config
config{
	virtual_text = false,
	underline = false,
	signs = false,
}


vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, { desc = "toggle diagnostic" })
