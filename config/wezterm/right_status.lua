local function show_date(wezterm)
	return wezterm.strftime("%Y-%m-%d %H:%M:%S")
end

local function show_battery(wezterm)
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
	end
	return bat
end

local function run(wezterm)
	local function callback(window, _)
		local text_list = {
			show_battery(wezterm),
			show_date(wezterm),
		}
		local text = table.concat(text_list, " | ")
		window:set_right_status(wezterm.format({
			{ Text = text },
		}))
	end

	wezterm.on("update-right-status", callback)
end

return {
	run = run,
}
