local M = {}

function M.convert_field_to_snake_case(field_name)
	if not field_name or type(field_name) ~= "string" or field_name == "" then
		vim.notify("Error: Field name is required for snake_case conversion.", vim.log.levels.ERROR)
		return
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}
	local pattern = field_name .. [[:\s*"]]
	local changed = false

	for _, line in ipairs(lines) do
		if line:find(pattern) then
			local new_line = line:gsub(pattern .. '([^"]*)"', function(value)
				local snake_case_value = value:gsub("%s+", "_"):gsub("[^%w_]", ""):lower()
				changed = true
				return field_name .. ': "' .. snake_case_value .. '"'
			end)
			table.insert(modified_lines, new_line)
		else
			table.insert(modified_lines, line)
		end
	end

	if changed then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
		vim.notify("Converted " .. field_name .. " values to snake_case.", vim.log.levels.INFO)
	else
		vim.notify("No " .. field_name .. " fields found to convert.", vim.log.levels.INFO)
	end
end

return M

