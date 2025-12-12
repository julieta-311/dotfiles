local M = {}

function M.convert_field_to_snake_case(field_name)
	if not field_name or type(field_name) ~= "string" or field_name == "" then
		vim.notify("Error: Field name is required for snake_case conversion.", vim.log.levels.ERROR)
		return
	end

	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	-- The field_name is inserted into the regex using string.format.
	-- Pattern: finds the field name, followed by ": ", a double quote, then captures everything
	-- that is NOT a quote inside the string, before the closing quote.
	local cmd = string.format(
		[[
    :%%s/%s: "\zs[^"]*\ze"/\=tolower(substitute(submatch(0), '[ .]', '_', 'g'))/g
  ]],
		field_name
	)

	local ok, err = pcall(function()
		vim.cmd(cmd)
	end)

	if not ok and not string.find(tostring(err), "E486") then
		vim.notify("An unexpected error occurred: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_win_set_cursor(0, cursor_pos)
	vim.notify("Finished converting spaces to snake_case for field: " .. field_name, vim.log.levels.INFO)
end

function M.unbreak_line(separator)
	local sep = separator or " " -- Use space if no separator is provided
	local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed line number

	-- Fetch the current line and the next line
	local lines = vim.api.nvim_buf_get_lines(0, line_num, line_num + 2, true)

	if #lines < 2 then
		vim.notify("Cannot unbreak line: end of buffer.", vim.log.levels.INFO)
		return
	end

	local current_line = lines[1]
	local next_line = lines[2]

	-- 1. Trim leading whitespace from the next line
	local next_line_trimmed = next_line:match("^%s*(.*)")

	-- 2. Concatenate: current line + separator + trimmed next line
	local new_line = current_line .. sep .. next_line_trimmed

	-- 3. Replace the current line with the combined line
	vim.api.nvim_buf_set_lines(0, line_num, line_num + 1, false, { new_line })

	-- 4. Delete the original next line
	vim.api.nvim_buf_set_lines(0, line_num + 1, line_num + 2, false, {})

	vim.notify("Lines joined with separator: '" .. sep .. "'", vim.log.levels.INFO)
end

return M
