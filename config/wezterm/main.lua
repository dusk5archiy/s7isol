local function generate_config(wezterm)
	local config = wezterm.config_builder()
	dofile(wezterm.config_dir .. "/right_status.lua").run(wezterm)
	config = dofile(wezterm.config_dir .. "/config.lua").generate_config(wezterm, config)
	config = dofile(wezterm.config_dir .. "/keyboard.lua").generate_config(wezterm, config)
	config = dofile(wezterm.config_dir .. "/ai.lua").generate_config(wezterm, config)
	return config
end

return generate_config(require("wezterm"))
