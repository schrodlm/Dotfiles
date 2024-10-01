local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.add({
  { "<leader>f", group = "file" },
  { "<leader>fb", ":Telescope file_browser path=%:p:help select_buffer=true<cr>", desc = "file browser" },
  { "<leader>fd", "<cmd>Telescope git_files<cr>", desc = "find git files" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find file" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "live grep" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "help tags" },
  { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "jumplist" },
  { "<leader>fm", "<cmd>Telescope keymaps<cr>", desc = "list all keymaps" },
  { "<leader>fo", "cmd> Telescope oldfiles<cr>", desc = "list old files" },
  { "<leader>ft", "<cmd>Telescope treesiter<cr>", desc = "treesitter" },
  { "<leader>fu", "<cmd>Telescope buffers<cr>", desc = "buffers" },
  { "<leader>g", "<cmd>Neogit<cr>", desc = "neogit" },
  { "<leader>r", "<cmd>vim.lsp.rename<cr>", desc = "rename" },
  { "<leader>t", "<cmd>belowright split +term | startinsert<cr>", desc = "terminal" },
  { "g", group = "variables" },
  { "gD", "<cmd>lua vim.ls.buf.declaration", desc = "declaration" },
  { "gI", "<cmd>lua vim.ls.buf.implementation", desc = "implementation" },
  { "gd", "<cmd>lua vim.lsp.buf.definition", desc = "definition" },
  { "gz", "<cmd>lua vim.lsp.buf.type_definition", desc = "type definition" },
})

wk.add({
  {
  mode = { "v" },
  { '<leader>"', desc = "surround with aphostrophes" },
  { "<leader>(", desc = "surround with parentheses" },
  { "<leader>[", desc = "surround with brackets" },
  { "<leader>fw", desc = "live grep selcted text" },
  { "<leader>{", desc = "surround with curly brackets" },
  },
})


