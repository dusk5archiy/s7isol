-- -----------------------------------------------------------------------------

local function generate_content(wezterm, prompt)
	-- Build the API endpoint URL
	local url = ai_config.base_url

	-- Prepare the request body following OpenAI API format
	local request_body = {
		model = ai_config.model,
		messages = {
			{
				role = "system",
				content = ai_config.system_prompt,
			},
			{
				role = "user",
				content = prompt,
			},
		},
	}

	-- Convert to JSON
	local json_body = wezterm.json_encode(request_body)

	-- Build curl command arguments
	local curl_args = {
		"curl",
		"-s",
		"-X",
		"POST",
		"-H",
		"Content-Type: application/json",
		url,
		"-d",
		json_body,
	}

	-- Add authorization header if API key is provided
	if ai_config.api_key then
		table.insert(curl_args, 5, "-H")
		table.insert(curl_args, 6, "Authorization: Bearer " .. ai_config.api_key)
	end

	-- Add custom headers if provided
	if ai_config.headers then
		for header_name, header_value in pairs(ai_config.headers) do
			table.insert(curl_args, 5, "-H")
			table.insert(curl_args, 6, header_name .. ": " .. header_value)
		end
	end

	local success, stdout, stderr = wezterm.run_child_process(curl_args)

	if not success then
		return false, "", stderr or "Failed to make HTTP request"
	end

	-- Parse the JSON response
	local ok, response = pcall(wezterm.json_parse, stdout)
	if not ok then
		return false, "", "Failed to parse API response: " .. stdout
	end

	-- Handle API errors
	if response.error then
		local error_msg = "API error: " .. (response.error.message or "Unknown error")
		return false, "", error_msg
	end

	-- Extract the content from the response
	if response.choices and response.choices[1] and response.choices[1].message then
		local content = response.choices[1].message.content
		return true, content, ""
	else
		return false, "", "Invalid API response format: " .. stdout
	end
end

-- -----------------------------------------------------------------------------

local function clear_line(wezterm, pane)
	if wezterm.separate == "\\" then
		pane:send_text("\x1b[2K\r")
	else
		pane:send_text("\u{15}\r")
	end
end

local function clean_response(response)
	if not response then
		return ""
	end

	-- Remove code fences
	response = response:gsub("```%w*\n?", "")
	response = response:gsub("```", "")

	-- Trim whitespace
	response = response:match("^%s*(.-)%s*$")

	return response
end

-- -----------------------------------------------------------------------------

local function parse_ai_response(wezterm, response)
	local cleaned = clean_response(response)
	local ok, json = pcall(wezterm.json_parse, cleaned)

	if not ok then
		wezterm.log_error("AI Helper: Failed to parse JSON response: ", cleaned)
		return {
			message = "❌ Error parsing AI response \r\n" .. cleaned,
			command = nil,
		}
	end

	if json and type(json) == "table" then
		return json
	end

	-- Fallback: treat as plain text message
	return {
		message = cleaned,
		command = nil,
	}
end

-- =============================================================================

local function ai_callback(wezterm, pane, prompt)
	if not prompt then
		return
	end
	if ai_config.show_loading then
		pane:inject_output("\r\n🤖 AI is thinking...")
	end
	local success, stdout, err = generate_content(wezterm, prompt)
	if success then
		wezterm.log_info("AI Helper: AI response received, response: ", stdout)
		local response = parse_ai_response(stdout)

		-- Display message if present
		if response.message and response.message ~= "" then
			pane:inject_output("\r\n💬 " .. response.message:gsub("[\n]", "\r\n"))
		end

		-- Clear current line and send command if present
		clear_line(pane)

		if response.command and response.command ~= "" then
			pane:send_text(response.command)
		end
	else
		-- Handle errors
		local error_msg = "❌ AI request failed"
		if err and err ~= "" then
			error_msg = error_msg .. ": " .. err
			wezterm.log_error("AI Helper err: ", err)
		end
		pane:inject_output("\r\n" .. error_msg)

		-- Still clear the line for user convenience
		clear_line(pane)
	end
end
