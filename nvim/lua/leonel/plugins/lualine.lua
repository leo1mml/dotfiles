-- Set lualine as statusline
-- See `:help lualine.txt`
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				-- theme = "tokyonight",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_x = {
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
			},
		})
	end,
}
