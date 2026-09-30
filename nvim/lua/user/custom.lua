local M = {}

--- Converts double-quoted strings to lowercase snake_case
--- on lines starting with "name:" in the current buffer.
function M.snake_case_name_fields()
	local bufnr = 0
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for idx, line in ipairs(lines) do
		if line:match("^%s*name:") then
			local new_line = line:gsub('("(.-)")', function(_, inner_text)
				local transformed = inner_text:lower():gsub("%s+", "_")
				return '"' .. transformed .. '"'
			end)
			vim.api.nvim_buf_set_lines(bufnr, idx - 1, idx, false, { new_line })
		end
	end
end

return M
