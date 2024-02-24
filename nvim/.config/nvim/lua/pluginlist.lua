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
    }
}

