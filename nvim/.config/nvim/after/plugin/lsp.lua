local on_attach = function(_, bufnr)

  local bufmap = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  bufmap('<leader>r', vim.lsp.buf.rename)
  bufmap('<leader>a', vim.lsp.buf.code_action)

  bufmap('gd', vim.lsp.buf.definition)
  bufmap('gD', vim.lsp.buf.declaration)
  bufmap('gI', vim.lsp.buf.implementation)
  bufmap('gz', vim.lsp.buf.type_definition)

  bufmap('gr', require('telescope.builtin').lsp_references)
  bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
  bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  bufmap('K', vim.lsp.buf.hover,  {buffer = bufnr})

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
  vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})



  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- require('lspconfig').lua_ls.setup{
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	Lua =  {
-- 		workspace = { checkThirdParty = false},
-- 		telemetry = {enable = false},
-- 	},
-- }

-- adding lsp server package manager (mason)
require("mason").setup()
require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup{
			on_attach = on_attach,
			capabilities = capabilities
		}
	end,
	
	["lua_ls"] = function()
		require('neodev').setup()
		require('lspconfig').lua_ls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			Lua = {
				workspace = {checkThirdParty = false},
				telemetry = {enable = false},
			},
		}
	end,
})

