local function get_theme_list(wezterm)
	local theme_file = io.open(wezterm.config_dir .. "/data/themes.json", "r")
	local theme_list = {
		"Catppuccin Mocha",
	}
	if theme_file then
		local file_content = theme_file:read("*a")
		theme_file:close()
		theme_list = wezterm.json_parse(file_content)
	end

	return theme_list
end

local function step(payload)
	local wezterm = payload.wezterm
	local utils = dofile(wezterm.config_dir .. "/utils.lua")
	local callback = function(window, _)
		local theme_list = get_theme_list(wezterm)

		local overrides = window:get_config_overrides() or {}
		local current_theme = overrides.color_scheme or ""
		local next_theme = utils.next_of(theme_list, current_theme)
		overrides.color_scheme = next_theme
		window:set_config_overrides(overrides)
	end

	local overrides = {
		{
			key = "F11",
			mods = "CTRL",
			action = wezterm.action_callback(callback),
		},
	}

	payload.config.keys = utils.merge_all(payload.config.keys or {}, overrides)
	return payload
end

return {
	step = step,
}
