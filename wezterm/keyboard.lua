local function step(payload)
	local wezterm = payload.wezterm
	local utils = dofile(wezterm.config_dir .. "/utils.lua")
	local overrides = {
		{ key = "F11", action = wezterm.action.ToggleFullScreen },

		{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal },
		{ key = "_", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical },

		{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
		{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },
	}
	payload.config.keys = utils.merge_all(payload.config.keys or {}, overrides)
	return payload
end

return {
	step = step,
}
