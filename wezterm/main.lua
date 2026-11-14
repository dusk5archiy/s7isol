local function main(wezterm)
	local config = wezterm.config_builder()
	local dir = wezterm.config_dir
	local payload = { wezterm = wezterm, config = config }
	payload = dofile(dir .. "/right_status.lua").step(payload)
	payload = dofile(dir .. "/bell.lua").step(payload)
	payload = dofile(dir .. "/config.lua").step(payload)
	payload = dofile(dir .. "/keyboard.lua").step(payload)
	payload = dofile(dir .. "/theme_toggle.lua").step(payload)
	payload = dofile(dir .. "/opacity_toggle.lua").step(payload)
	return payload.config
end

return main(require("wezterm"))
