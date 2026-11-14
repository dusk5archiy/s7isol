local function step(payload)
	local wezterm = payload.wezterm
	local utils = dofile(wezterm.config_dir .. "/utils.lua")
	local callback = function(window, _)
		local overrides = window:get_config_overrides() or {}
		local current_opacity = overrides.window_background_opacity
			or window:effective_config().window_background_opacity
			or 0.8

		if current_opacity < 1.0 then
			overrides.window_background_opacity = 1.0
		else
			overrides.window_background_opacity = 0.8
		end
		window:set_config_overrides(overrides)
	end

	local overrides = {
		{
			key = "F11",
			mods = "SHIFT",
			action = wezterm.action_callback(callback),
		},
	}

	payload.config.keys = utils.merge_all(payload.config.keys or {}, overrides)
	return payload
end

return {
	step = step,
}
