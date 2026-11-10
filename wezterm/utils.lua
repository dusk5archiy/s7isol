local function merge_all(...)
	local is_list = false

	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if type(t) == "table" and #t > 0 then
			is_list = true
			break
		end
	end

	local result = {}

	for i = 1, select("#", ...) do
		local current_table = select(i, ...)

		if type(current_table) == "table" then
			if is_list then
				for _, v in ipairs(current_table) do
					table.insert(result, v)
				end
			else
				for k, v in pairs(current_table) do
					result[k] = v
				end
			end
		end
	end

	return result
end

local function next_of(table, item)
	local current_index = #table
	for index, value in ipairs(table) do
		if value == item then
			current_index = index
			break
		end
	end
	local next_index = current_index % #table + 1
	return table[next_index]
end

return {
	merge_all = merge_all,
	next_of = next_of,
}
