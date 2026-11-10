local function step(payload)
	local wezterm = payload.wezterm
	local function callback()
		wezterm.background_child_process({
			"pw-play",
			"/usr/share/sounds/freedesktop/stereo/bell.oga",
		})
	end

	wezterm.on("bell", callback)
	return payload
end

return {
	step = step,
}
