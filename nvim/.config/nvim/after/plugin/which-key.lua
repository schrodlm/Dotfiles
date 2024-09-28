local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register({
  ["<leader>"] = {
	f = {
		name = "+file",
		f = { "<cmd>Telescope find_files<cr>", 	"find file" },
		g = { "<cmd>Telescope live_grep<cr>", 	"live grep"},
		b = { ":Telescope file_browser path=%:p:h select_buffer=true<cr>", "file browser"},	
		u = { "<cmd>Telescope buffers<cr>", 	"buffers"},
		h = { "<cmd>Telescope help_tags<cr>", 	"help tags"},
		o = { "cmd> Telescope oldfiles<cr>", 	"list old files"},
		j = { "<cmd>Telescope jumplist<cr>", 	"jumplist" },
		t = { "<cmd>Telescope treesiter<cr>", 	"treesitter" },	
		d = { "<cmd>Telescope git_files<cr>", 	"find git files"},	
		m = { "<cmd>Telescope keymaps<cr>", 	"list all keymaps"},
    },
	r = {"<cmd>vim.lsp.rename<cr>",				"rename"},
	g = {"<cmd>Neogit<cr>",			                "neogit"},
	t = {"<cmd>belowright split +term | startinsert<cr>",   "terminal"}
  },
  	["g"] =
	{
		name = "+variables",
		d = {"<cmd>lua vim.lsp.buf.definition","definition"},
		D = {"<cmd>lua vim.ls.buf.declaration","declaration"},
		I = {"<cmd>lua vim.ls.buf.implementation", "implementation"},
		z = {"<cmd>lua vim.lsp.buf.type_definition", "type definition"},

	}
})

wk.register({
	["<leader>"] = {
		["("] = {"surround with parentheses"},
		["{"] = {"surround with curly brackets"},
		["["] = {"surround with brackets"},
		["\""] = {"surround with aphostrophes"},
		fw = {"live grep selcted text"},
	}
}, { mode = "v"})


