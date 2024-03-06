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
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      n = { "<cmd>enew<cr>", "New File" },
    	},
	r = {"<cmd>vim.lsp.rename<cr>","rename"},
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
		["["] = {"surround with brackets"}
	}
}, { mode = "v"})


