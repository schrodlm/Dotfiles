return {
	--comments 
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end
	},
	-- color scheme
	{
		"rebelot/kanagawa.nvim",
		priority = 1000, 
		config = function()
			vim.cmd("colorscheme kanagawa-wave")
		end
	},
	-- lualine
	{
        'nvim-lualine/lualine.nvim',
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
    },
	-- these plugins are then set in after/plug directory which neovim will source after all plugins have been loaded, 
	-- that means settings in after/plugins directory cannot be overriden 
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	'folke/neodev.nvim',
}

