local appearance = {
	color_scheme = os.getenv("CONFIG_WEZTERM_THEME") or "Kanagawa (Gogh)",
	window_background_opacity = 1.0,
	colors = {
		tab_bar = {
			background = "none",

			active_tab = {
				bg_color = "none",
				fg_color = "white",
				intensity = "Bold",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				fg_color = "#aaa",
				bg_color = "none",
				italic = false,
			},
			inactive_tab_hover = {
				fg_color = "#ddd",
				bg_color = "none",
				italic = true,
			},
			new_tab = { fg_color = "#ddd", bg_color = "none" },
			new_tab_hover = { fg_color = "white", bg_color = "none" },
		},
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
