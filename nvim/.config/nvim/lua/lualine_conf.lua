-- Lualine Configuration 
-- This configuration is mainly implemented from their github repository.

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {{

		-- writes out the encoding only if it is not utf-8
		function()
			local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
  			return ret
			end
	},
	{
		-- writes out the file formatting only if it is not unix LF formatting
		function()
			local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
  			return ret
			end
	}
	, 'filetype'},
	lualine_y = {
    -- word count for file formats like txt, latex, ...
		{
        function()
            local words = vim.fn.wordcount()['words']
            return 'Words: ' .. words
        end,
        cond = function()
            local ft = vim.opt_local.filetype:get()
            local count = {
                latex = true,
                tex = true,
                text = true,
                markdown = true,
                vimwiki = true,
            }
            return count[ft] ~= nil
        end,
    },
},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
