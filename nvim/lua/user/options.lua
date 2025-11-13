-- Set leader key.
vim.g.mapleader = " "

-- Basic editor settings.
vim.opt.number = true -- Show line numbers.
vim.opt.relativenumber = true -- Show relative line numbers.
vim.opt.mouse = "a" -- Enable mouse support.
vim.opt.clipboard = "unnamedplus" -- Use system clipboard.
vim.opt.autochdir = true -- Automatically change directory to the current file's directory.
vim.opt.shiftwidth = 4 -- Number of space characters inserted for indentation.
vim.opt.background = "dark" -- Use a dark background.

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Ctags.
vim.opt.tags:append("./tags;")

-- Spelling.
vim.opt.spell = true
-- Custom spell highlighting.
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "red" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "yellow" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "blue" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "orange" })

-- Enable filetype detection, plugins, and indentation.
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Custom command for :W to write file.
vim.api.nvim_create_user_command("W", "write", {})

-- Autocmd for Go files.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "yaml", "yml", "lua", "html", "css", "sql" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
	end,
})
