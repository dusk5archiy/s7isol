local dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])") or "./"

local CONFIG_NVIM_TRANSPARENT = os.getenv("CONFIG_NVIM_TRANSPARENT") == "1"

return {
	dofile(dir .. "lualine.lua"),
	dofile(dir .. "snack.lua"),
	dofile(dir .. "mason.lua"),
	dofile(dir .. "mini.pairs.lua"),
	dofile(dir .. "bufferline.lua"),
	-- theme
	{ "rebelot/kanagawa.nvim", name = "kanagawa", opts = {
		transparent = CONFIG_NVIM_TRANSPARENT,
	} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			transparent_background = CONFIG_NVIM_TRANSPARENT,
			float = {
				transparent = true,
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = os.getenv("CONFIG_NVIM_THEME") or "catppuccin",
		},
	},
}
