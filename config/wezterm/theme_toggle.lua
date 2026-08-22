local function generate_config(wezterm, config)
	local utils = dofile(wezterm.config_dir .. "/utils.lua")
	local theme_file = io.open(wezterm.config_dir .. "/data/themes.json", "r")
	local theme_list = {
		"Kanagawa (Gogh)",
	}
	if theme_file then
		local file_content = theme_file:read("*a")
		theme_file:close()
		theme_list = wezterm.json_parse(file_content)
	end

	local callback = function(window, _)
		local overrides = window:get_config_overrides() or {}
		local current_theme = overrides.color_scheme or ""
		local next_theme = utils.next_of(theme_list, current_theme)
		overrides.color_scheme = next_theme
		window:set_config_overrides(overrides)
	end

	local overrides = {
		{
			key = "F9",
			action = wezterm.action_callback(callback),
		},
	}

	config.keys = utils.merge_all(config.keys or {}, overrides)
	return config
end

return {
	generate_config = generate_config,
}
