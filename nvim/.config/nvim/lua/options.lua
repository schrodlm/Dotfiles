
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus'

-- turn on hybrid line numbering
vim.o.relativenumber = true
vim.o.number = true

--vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='grey' })

vim.o.signcolumn = 'yes'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = 'a'

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
