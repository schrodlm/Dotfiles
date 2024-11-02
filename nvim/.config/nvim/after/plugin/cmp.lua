local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
-- TODO: Maybe get rid of the snippets
local lspkind = require('lspkind')
cmp.setup {

    enabled = function()
      local context = require 'cmp.config.context'
	  -- disables completion in Telescope and other prompt buffers
	  if vim.bo.buftype == 'prompt' then
		return false
		end
      -- disable completion in comments
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
    end,

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = { 
        ["<C-Up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior, count = 1}),
        ["<C-Down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior, count = 1}),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
	['<c-space>'] = cmp.mapping.complete(),

        -- Custom Down and Up mappings to close completion menu and move one line in the specified direction
        ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), 'n', true)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, true, true), 'n', true)
            else
                fallback()
            end
        end, { "i", "s" }),

	-- Moving items with TAB
    --     ['<Tab>'] = cmp.mapping(function(fallback)
    --         if cmp.visible() then
    --             cmp.select_next_item()
    --         elseif luasnip.expand_or_locally_jumpable() then
    --             luasnip.expand_or_jump()
    --         else
    --             fallback()
    --         end
    --     end, { 'i', 's' }),
    --     ['<S-Tab>'] = cmp.mapping(function(fallback)
    --         if cmp.visible() then
    --             cmp.select_prev_item()
    --         elseif luasnip.locally_jumpable(-1) then
    --             luasnip.jump(-1)
    --         else
    --             fallback()
    --         end
    --     end, { 'i', 's' }),
    },
	-- how long do I have type to start showing keywords
	sources = {
        { name = 'nvim_lsp', keyword_length = 2},
		{ name = 'path', keyword_length = 2},
        { name = 'luasnip', keyword_length = 2},
		{ name = 'buffer', keyword_length = 2},
    },
	-- shows source of where the completion originated from 
	formatting = {
		format = lspkind.cmp_format{
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				path = "[path]",
				luasnip = "[snip]",
			},
		},
	},
	-- virtual text [testing]
	experimental = {
		ghost_text = true,
	},
}
