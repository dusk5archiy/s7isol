local dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])") or "./"

local payload = {
	transparent = (os.getenv("CONFIG_NVIM_TRANSPARENT") or "1") == "1",
	colorscheme = os.getenv("CONFIG_NVIM_THEME") or "catppuccin-nvim",
}

return {
	dofile(dir .. "../_custom/lazyvim.lua")(payload),
	dofile(dir .. "../_custom/lualine.lua"),
	dofile(dir .. "../_custom/clangd.lua"),
	dofile(dir .. "../_custom/snack.lua"),
	dofile(dir .. "../_custom/mini.pairs.lua"),
	dofile(dir .. "../_custom/mason.lua"),
	dofile(dir .. "../_custom/bufferline.lua"),
	dofile(dir .. "../_appearance/kanagawa.lua")(payload),
	dofile(dir .. "../_appearance/catppuccin.lua")(payload),
}
