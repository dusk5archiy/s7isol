local function run(wezterm)
	local function on_update_right_status(window, _)
		local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")

		local bat = ""
		for _, b in ipairs(wezterm.battery_info()) do
			bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100) .. "  "
		end

		window:set_right_status(wezterm.format({
			{ Text = bat .. date },
		}))
	end

	wezterm.on("update-right-status", on_update_right_status)
end

return {
	run = run,
}
