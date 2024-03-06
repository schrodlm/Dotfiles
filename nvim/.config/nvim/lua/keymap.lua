
--Telescope + LSP--
----------------------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
vim.keymap.set('n', '<leader>fd', builtin.git_files, {})
vim.keymap.set('n', '<leader>fm', builtin.keymaps, {})
-- visual mode
vim.keymap.set('v', '<leader>fg', builtin.grep_string,{})



--- Neogit ---
----------------------------------------------------------------
local neogit = require('neogit')
vim.keymap.set('n', '<leader>go',neogit.open, {})
vim.keymap.set('n', '<leader>gc', function() 
									neogit.open({"commit"}) 
									end,{})

