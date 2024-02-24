return{
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


}

