local wezterm = require("wezterm")

-- -----------------------------------------------------------------------------

wezterm.on("update-right-status", function(window, _)
	local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")

	window:set_right_status(wezterm.format({
		{ Text = date },
	}))
end)

-- -----------------------------------------------------------------------------

local function merge_all(...)
	local result = {}

	for i = 1, select("#", ...) do
		local current_table = select(i, ...)

		if type(current_table) == "table" then
			for k, v in pairs(current_table) do
				result[k] = v
			end
		end
	end

	return result
end

-- -----------------------------------------------------------------------------

local appearance = {
	color_scheme = "Kanagawa (Gogh)",
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
	font_size = 10,
	text_background_opacity = 1.0,
}

local backend = {
	enable_wayland = false,
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
}

local keyboard = {
	keys = {
		{ key = "F11", action = wezterm.action.ToggleFullScreen },

		{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal },
		{ key = "_", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical },

		{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
		{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },
	},
}

return merge_all(appearance, text, backend, env, window_layout, keyboard, other)
