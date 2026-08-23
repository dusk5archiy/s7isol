local appearance = {
	color_scheme = os.getenv("CONFIG_WEZTERM_THEME") or "Kanagawa (Gogh)",
	window_background_opacity = 1.0,
	audible_bell = "Disabled",
	visual_bell = {
		fade_in_duration_ms = 75,
		fade_out_duration_ms = 75,
	},
	colors = {
		visual_bell = "#330000",
	},
}

-- -----------------------------------------------------------------------------

local text = {
	font_size = 9,
	text_background_opacity = 1.0,
}

local backend = {
	enable_wayland = os.getenv("CONFIG_WEZTERM_DISPLAY") == "wayland",
	force_reverse_video_cursor = true,
	freetype_load_target = "Normal",
	front_end = "Software",
}

local env = {
	set_environment_variables = {},
}

local window_layout = {
	initial_cols = 100,
	initial_rows = 20,
	show_tab_index_in_tab_bar = true,
	tab_and_split_indices_are_zero_based = false,
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
}

local other = {
	adjust_window_size_when_changing_font_size = false,
	window_close_confirmation = "NeverPrompt",
}

local function generate_config(wezterm, config)
	local utils = dofile(wezterm.config_dir .. "/utils.lua")
	config = utils.merge_all(config, appearance, text, backend, env, window_layout, other)
	return config
end

return {
	generate_config = generate_config,
}
