local M = {}

function M.snake_case_names()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- We will run the substitute command without the 'e' flag this time.
  local cmd = [[
    :%s/name: "\zs\(.*\)\ze"/\=tolower(substitute(submatch(1), '[ .]', '_', 'g'))/g
  ]]

  -- pcall (protected call) runs a function and catches any errors without crashing.
  -- 'ok' will be true if it succeeds, false if it fails.
  local ok, err = pcall(vim.cmd, cmd)

  -- We only care if an error occurred AND it was NOT the "Pattern not found" error.
  if not ok and not string.find(tostring(err), "E486") then
    -- This is an unexpected error, so we should show it.
    vim.notify("An unexpected error occurred: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  -- If we're here, it means either the command succeeded, or it failed with the
  -- "Pattern not found" error we want to ignore.

  vim.api.nvim_win_set_cursor(0, cursor_pos)
  vim.notify("Finished checking for test names to convert.", vim.log.levels.INFO)
end

return M
