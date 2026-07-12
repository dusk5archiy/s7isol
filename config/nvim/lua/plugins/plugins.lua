return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
		},
	},
	-- theme
	{ "rebelot/kanagawa.nvim", name = "kanagawa", opts = {} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			transparent_background = true,
			float = {
				transparent = true,
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "kanagawa",
		},
	},
	-- dashboard
	{
		"snacks.nvim",
		opts = {
			dashboard = {
				formats = {
					footer = { "%s", align = "center" },
					cache = false,
					ttl = 0,
				},
				sections = {
					{ section = "startup" },
				},
			},
		},
	},
}
