local function merge_all(...)
	local result = {}

	for i = 1, select("#", ...) do
		local current_table = select(i, ...)

		if type(current_table) == "table" then
			for k, v in pairs(current_table) do
				result[k] = v
			end
		end
	end

	return result
end

return {
	merge_all = merge_all,
}
