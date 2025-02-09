return{
-- smt-libv2 syntax
{
  "bohlender/vim-smt2"
},
-- comments 
{
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end
}, -- color scheme
{
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
		require('kanagawa').setup({
    		colors = {
        		theme = {
            		all = {
                		ui = {
                    		bg_gutter = "none"
                		}
            		}
        		}
    },
	-- adding color to current line number
	overrides = function(colors)
     	   return {
						LineNr = {fg= colors.palette.lotusOrange, bold = true},
						LineNrAbove = {fg = colors.palette.dragonGray},
						LineNrBelow = {fg = colors.palette.dragonGray},
        	}
    end,

})

    vim.cmd("colorscheme kanagawa-wave")
    end
}, -- these plugins are then set in after/plug directory which neovim will source after all plugins have been loaded, 
-- that means settings in after/plugins directory cannot be overriden 
"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", 'folke/neodev.nvim', {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
},

{
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim'}
},

{
		'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' 
},

-- lualine
{
    'nvim-lualine/lualine.nvim',
    dependencies = {"nvim-tree/nvim-web-devicons"}
},
-- neogit
{
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = true
},
-- which-key
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
},
-- file browser
{
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
},
{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-buffer', 		-- nvim-cmp source for buffer words
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lsp',

			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
			'onsails/lspkind.nvim',
		},
},
-- quick scope
{
		'unblevable/quick-scope',
    init = function()
      -- QuickScope
      vim.cmd [[
      " Trigger a highlight in the appropriate direction when pressing these keys:
      let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
			" Your .vimrc
			highlight QuickScopePrimary guifg='#ffbf00' gui=underline 
			highlight QuickScopeSecondary guifg='#bf94e4' gui=underline 
      ]]
    end,
},
{
	'cohama/lexima.vim'
},
	{
		'nvim-treesitter/playground'
	}

}


