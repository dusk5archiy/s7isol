local dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])") or "./"

return {
	dofile(dir .. "lualine.lua"),
	dofile(dir .. "snack.lua"),
	dofile(dir .. "mason.lua"),
	dofile(dir .. "mini.pairs.lua"),
	dofile(dir .. "bufferline.lua"),
	-- theme
	{ "rebelot/kanagawa.nvim", name = "kanagawa", opts = {} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			transparent_background = os.getenv("CONFIG_NVIM_TRANSPARENT") == "1",
			float = {
				transparent = true,
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = os.getenv("CONFIG_NVIM_THEME") or "kanagawa",
		},
	},
}
