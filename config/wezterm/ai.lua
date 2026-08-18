local ai_config = {
	model = os.getenv("CONFIG_WEZTERM_AI_MODEL") or "google/gemma-3-4b",
	api_key = os.getenv("CONFIG_WEZTERM_AI_AUTH_TOKEN") or "",
	base_url = (function()
		local base_url = os.getenv("CONFIG_WEZTERM_AI_BASE_URL") or "http://localhost:11434"
		return base_url .. "/v1"
	end)(),
}
local function fetch_models(wezterm)
	local curl_args = {
		"curl",
		"-s",
		ai_config.base_url .. "/models",
		"-H",
		"Content-Type: application/json",
		"-H",
		"Authorization: Bearer " .. ai_config.api_key,
	}
	local success, stdout, stderr = wezterm.run_child_process(curl_args)
	if not success then
		return "Error fetching models: " .. tostring(stderr)
	end
	return stdout
end

local function generate_config(wezterm, config)
	local utils = dofile(wezterm.config_dir .. "/utils.lua")

	local overrides = {
		{
			key = "F9",
			action = wezterm.action.PromptInputLine({
				description = "Command:",
				action = wezterm.action_callback(function(window, pane, line)
					if not line or line == "" then
						return
					end

					if line:lower() == "models" then
						local response = fetch_models(wezterm)
						if not config.enable_wayland then
							window:toast_notification("AI Models", response, nil, 4000)
						else
							pane:inject_output("\r\n--- API Models Response ---\r\n" .. response .. "\r\n")
						end
					end
				end),
			}),
		},
	}

	config.keys = utils.merge_all(config.keys or {}, overrides)
	return config
end

return {
	generate_config = generate_config,
}
