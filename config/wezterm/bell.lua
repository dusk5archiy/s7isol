local function run(wezterm)
	local function callback()
		wezterm.background_child_process({
			"pw-play",
			"/usr/share/sounds/Yaru/stereo/bell.oga",
		})
	end

	wezterm.on("bell", callback)
end

return {
	run = run,
}
