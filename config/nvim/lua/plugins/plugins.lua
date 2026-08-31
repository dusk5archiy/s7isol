local dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])") or "./"

local configUseTransparent = (os.getenv("CONFIG_NVIM_TRANSPARENT") or "1") == "1"

return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = os.getenv("CONFIG_NVIM_THEME") or "catppuccin-nvim",
		},
	},
	dofile(dir .. "lualine.lua"),
	dofile(dir .. "snack.lua"),
	dofile(dir .. "mason.lua"),
	dofile(dir .. "mini.pairs.lua"),
	dofile(dir .. "bufferline.lua"),
	-- themes
	{ "rebelot/kanagawa.nvim", name = "kanagawa", opts = {
		transparent = configUseTransparent,
	} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = configUseTransparent,
			float = {
				transparent = configUseTransparent,
			},
		},
	},
}
