return {
	{
		"echasnovski/mini.comment",
		version = false,
		config = function()
			require("mini.comment").setup({
				mappings = {
					comment = "<leader>/",
					comment_line = "<leader>/",
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-s>"] = actions.select_vertical, -- Map Ctrl-s for vertical split
							["<C-h>"] = actions.select_horizontal, -- Map Ctrl-h for horizontal split
							-- <C-v> is left unmapped for pasting
						},
						n = {
							["<C-s>"] = actions.select_vertical,
							["<C-h>"] = actions.select_horizontal,
						},
					},
				},
			})

			-- Load Telescope extensions (keep this if you use harpoon with Telescope)
			telescope.load_extension("harpoon")
		end,
		keys = {
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>gp",
				function()
					require("telescope.builtin").live_grep({
						cwd = vim.fn.expand("%:p:h:h"),
					})
				end,
				desc = "Grep in parent directory",
			},
			{
				"<leader>gg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>tt",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find buffers",
			},
			{
				"<leader>bt",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Find help tags",
			},
			{
				"<leader>fc",
				function()
					local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
					if vim.v.shell_error == 0 and git_root then
						require("telescope.builtin").find_files({ cwd = git_root })
					else
						require("telescope.builtin").find_files()
					end
				end,
				desc = "Find files in repo root",
			},
			{
				"<leader>gc",
				function()
					local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
					if vim.v.shell_error == 0 and git_root then
						require("telescope.builtin").live_grep({ cwd = git_root })
					else
						require("telescope.builtin").live_grep()
					end
				end,
				desc = "Grep in repo root",
			},
			{
				"<leader>gn",
				function()
					require("telescope.builtin").live_grep({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Grep in neovim config",
			},
			{
				"<leader>fn",
				function()
					require("telescope.builtin").find_files({
						cwd = vim.fn.stdpath("config"),
					})
				end,
				desc = "Find files in neovim config",
			},
			-- Harpoon Telescope integration
			{
				"<leader>th",
				function()
					require("telescope").extensions.harpoon.marks()
				end,
				desc = "Telescope Harpoon marks",
			},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({

				sort_by = "case_sensitive",

				view = {

					width = 30,
				},

				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local opts = { noremap = true, silent = true, buffer = bufnr }

					vim.keymap.set("n", "<CR>", api.node.open.edit, opts)
					vim.keymap.set("n", "o", api.node.open.edit, opts)
					vim.keymap.set("n", "s", api.node.open.vertical, opts)
					vim.keymap.set("n", "v", api.node.open.horizontal, opts)
				end,
			})

			-- Auto-open nvim-tree when Neovim starts with no files listed
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if #vim.api.nvim_list_bufs() == 1 and vim.api.nvim_buf_get_name(0) == "" then
						vim.cmd("NvimTreeOpen")
					end
				end,
			})
		end,
	},

	-- Seamless navigation between tmux and vim splits.
	{ "christoomey/vim-tmux-navigator" },

	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	{
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<leader>sl", "<cmd>AutoSession search<CR>", desc = "Session search" },
			{ "<leader>ss", "<cmd>AutoSession save<CR>", desc = "Save session" },
			{ "<leader>sa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
		},

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			-- The following are already the default values, no need to provide them if these are already the settings you want.
			session_lens = {
				picker = nil, -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also manually choose one. Falls back to vim.ui.select
				mappings = {
					-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
					delete_session = { "i", "<C-d>" },
					alternate_session = { "i", "<C-s>" },
					copy_session = { "i", "<C-y>" },
				},

				picker_opts = { border = true },

				-- Telescope only: If load_on_setup is false, make sure you use `:AutoSession search` to open the picker as it will initialize everything first
				load_on_setup = true,
			},
		},
	},

	------------------------------------------------------------------
	-- Syntax Highlighting
	------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Automatically installs and updates parsers
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all"
				ensure_installed = { "go", "lua", "python", "vim", "vimdoc", "yaml" },

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				auto_install = true,

				highlight = {
					enable = true, -- Enable syntax highlighting
				},
			})
		end,
	},

	------------------------------------------------------------------
	-- LSP and Autocompletion
	------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
			})

			-- Setup completion.
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			-- 1. Create a global autocommand for LSP keymaps
			-- This defines keymaps for ALL language servers in one place.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
				end,
			})

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
							nilness = true,
							revive = true,
							unusedresult = true,
							httpresponse = true,
							ST1000 = false,
							QF1008 = false,
							ST1003 = false,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})
			vim.lsp.enable("gopls")

			-- Autocmd for Go imports and formatting on save (Neovim v0.11+ compliant)
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function(ev)
					local bufnr = ev.buf
					local winid = vim.fn.bufwinid(bufnr)

					if winid == -1 then
						return
					end

					-- Get active LSP clients attached to this specific buffer
					local clients = vim.lsp.get_clients({ bufnr = bufnr })
					if #clients == 0 then
						return
					end

					-- Use the first active client's offset encoding (typically utf-8/utf-16 for gopls)
					local client = clients[1]
					local offset_encoding = client.offset_encoding or "utf-16"

					-- Pass both required arguments: window ID and position encoding
					-- Derive the standard range parameters
					local base_params = vim.lsp.util.make_range_params(winid, offset_encoding)

					-- Safely merge the parameters into a generic table to suppress "inject-field" errors
					local params = vim.tbl_extend("force", base_params, {
						context = { only = { "source.organizeImports" } },
					})

					local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end

					-- Complete buffer-specific format sync execution
					vim.lsp.buf.format({ bufnr = bufnr, async = false })
				end,
			})
			vim.lsp.config("ty", {
				cmd = { "ty", "server" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "ty.toml", ".git" },
			})
			vim.lsp.enable("ty")
			vim.lsp.enable("ts_ls")

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},

	{ "junegunn/vim-easy-align" },

	{ "webastien/vim-ctags" },

	-- Statusline.
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto", -- or a specific theme like 'tokyonight'
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		keys = {
			{ "<leader>bb", "<Cmd>BufferLinePick<CR>", desc = "Pick a buffer" },
			{ "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
			{ "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
			{ "<leader>bc", "<Cmd>bdelete<CR>", desc = "Close buffer" },
			{ "<leader>bq", "<Cmd>BufferLinePickClose<CR>", desc = "Pick and close a buffer" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close all other buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close buffers to the right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close buffers to the left" },
		},
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							highlight = "Directory",
							text_align = "left",
							separator = true,
						},
					},
					separator_style = "thin",
					-- Use `show_buffer_close_icons` and `show_close_icon` to configure close icons
					show_buffer_close_icons = true,
					show_close_icon = true,
					-- Set the indicator style
					indicator = {
						style = "icon",
						icon = "▎",
					},
				},
			})
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("harpoon"):setup({
				global_settings = {
					save_on_change = true,
				},
			})

			vim.keymap.set("n", "<leader>ha", function()
				require("harpoon"):list():append()
				vim.notify("Harpooned " .. vim.fn.expand("%:t"), vim.log.levels.INFO, { title = "Harpoon" })
			end, { desc = "Harpoon: Add file to list" })

			vim.keymap.set("n", "<leader>hh", function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end, { desc = "Harpoon: Toggle quick menu" })

			vim.keymap.set("n", "<leader>h1", function()
				require("harpoon"):list():select(1)
			end, { desc = "Harpoon: Go to file 1" })

			vim.keymap.set("n", "<leader>h2", function()
				require("harpoon"):list():select(2)
			end, { desc = "Harpoon: Go to file 2" })

			vim.keymap.set("n", "<leader>h3", function()
				require("harpoon"):list():select(3)
			end, { desc = "Harpoon: Go to file 3" })

			vim.keymap.set("n", "<leader>h4", function()
				require("harpoon"):list():select(4)
			end, { desc = "Harpoon: Go to file 4" })

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-H>", function()
				require("harpoon"):list():prev()
			end, { desc = "Harpoon: Go to previous file" })

			vim.keymap.set("n", "<C-h>", function()
				require("harpoon"):list():next()
			end, { desc = "Harpoon: Go to next file" })

			-- Substitute harpooneed file.
			vim.keymap.set("n", "<leader>hr", function()
				require("harpoon"):list():replace_at(1)
			end, { desc = "Harpoon: Substitute first harpooneed file" })
			vim.keymap.set("n", "<leader>hrr", function()
				require("harpoon"):list():replace_at(2)
			end, { desc = "Harpoon: Substitute second harpooneed file" })
			vim.keymap.set("n", "<leader>hrrr", function()
				require("harpoon"):list():replace_at(3)
			end, { desc = "Harpoon: Substitute third harpooneed file" })
			vim.keymap.set("n", "<leader>hrrrr", function()
				require("harpoon"):list():replace_at(4)
			end, { desc = "Harpoon: Substitute fourth harpooneed file" })
		end,
	},

	-- Autoformatter.
	{
		"stevearc/conform.nvim",
		opts = {
			-- A list of formatters to install if they are not already available.
			-- conform.nvim will manage their installation via mason.nvim.
			-- Make sure you have mason.nvim installed.
			ensure_installed = { "prettier" },

			-- Set up format-on-save
			format_on_save = {
				timeout_ms = 10000,
				lsp_fallback = true,
			},

			formatters = {
				prettier = {
					prepend_args = {
						"--single-quote=false",
						"--print-width=120",
					},
				},
				-- Create a custom prettier formatter for YAML that forces double quotes.
				prettier_yaml = {
					command = "prettier",
					stdin = true,
					args = {
						"--stdin-filepath",
						"$FILENAME",
						"--parser",
						"yaml",
						"--single-quote=false",
					},
				},
				-- sqlfluff with dbt templater - finds dbt project by walking up from file.
				sqlfluff = {
					command = vim.fn.expand("~/.venvs/sqlfluff/bin/sqlfluff"),
					stdin = false,
					-- Format the actual file in place (no temp file) so dbt can find project structure.
					tmpfile_format = "$FILENAME",
					-- sqlfluff exits with code 1 when it fixes violations, treat as success.
					exit_codes = { 0, 1 },
					args = { "fix", "--dialect=bigquery", "$FILENAME" },
					cwd = function(_, ctx)
						-- Find dbt_project.yml by walking up from the file.
						local file_dir = vim.fn.fnamemodify(ctx.filename, ":h")
						local current_dir = file_dir

						while current_dir ~= "/" do
							local dbt_project = current_dir .. "/dbt_project.yml"
							if vim.fn.filereadable(dbt_project) == 1 then
								return current_dir
							end
							current_dir = vim.fn.fnamemodify(current_dir, ":h")
						end

						-- Fallback: use file directory.
						return file_dir
					end,
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },

				python = { "ruff_organize_imports", "ruff_format" },

				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				less = { "prettier" },
				html = { "prettier" },
				json = { "jq" },
				yaml = { "prettier_yaml" },
				markdown = { "prettier" },
				graphql = { "prettier" },

				go = { "gofmt", "goimports" },
				sql = { "sqlfluff" },
			},
		},
	},

	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_filetypes = {
				["*"] = true,
				["help"] = false,
				["gitcommit"] = false,
				["gitrebase"] = false,
			}
			vim.g.copilot_no_tab_map = true
			vim.keymap.set("i", "<leader><Tab>", function()
				vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](), "i", true)
			end, { noremap = true, silent = true, desc = "Copilot: Accept suggestion" })
		end,
	},

	-- Git integration.
	{ "tpope/vim-fugitive" },
	{ "tommcdo/vim-fugitive-blame-ext" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				attach_to_untracked = true,
				current_line_blame = true,
				update_debounce = 300, -- default is 100.
				max_file_length = 40000, -- Disable for files over 40,000 lines.
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function(bufnr)
					-- Disable for large files (over 200KB).
					local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
					if size > 200 * 1024 then
						return false
					end
					--- Define keymaps.
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation.
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next Git hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous Git hunk" })

					-- Actions.
					map("n", "<leader>gh", gs.preview_hunk, { desc = "Preview Git hunk" })
					map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Git hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Git hunk" })
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage selected lines" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset selected lines" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Git blame line" })
				end,
			})
		end,
	},

	-- Linting (includes sqlfluff for SQL).
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			-- Override sqlfluff linter to set working directory to dbt project
			lint.linters.sqlfluff = vim.tbl_deep_extend("force", lint.linters.sqlfluff or {}, {
				cmd = vim.fn.expand("~/.venvs/sqlfluff/bin/sqlfluff"),
				stdin = false,
				args = { "lint", "--format=json", "--dialect=bigquery" },
				cwd = function()
					local file_path = vim.api.nvim_buf_get_name(0)
					local file_dir = vim.fn.fnamemodify(file_path, ":h")
					local current_dir = file_dir

					-- Find dbt_project.yml by walking up
					while current_dir ~= "/" do
						local dbt_project = current_dir .. "/dbt_project.yml"
						if vim.fn.filereadable(dbt_project) == 1 then
							return current_dir
						end
						current_dir = vim.fn.fnamemodify(current_dir, ":h")
					end

					return file_dir
				end,
			})

			lint.linters_by_ft = {
				sql = { "sqlfluff" },
				yaml = { "yamllint" },
				python = { "ruff" },
				json = { "jsonlint" },
			}

			-- Auto-lint on buffer open and while editing (not just on save).
			local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
				end,
			})

			-- Toggle linting on/off
			vim.g.lint_enabled = true
			vim.keymap.set("n", "<leader>tl", function()
				vim.g.lint_enabled = not vim.g.lint_enabled
				if vim.g.lint_enabled then
					vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
						group = lint_augroup,
						callback = function()
							require("lint").try_lint()
						end,
					})
					require("lint").try_lint()
					vim.notify("Linting enabled", vim.log.levels.INFO)
				else
					vim.api.nvim_clear_autocmds({ group = lint_augroup })
					vim.diagnostic.reset()
					vim.notify("Linting disabled", vim.log.levels.INFO)
				end
			end, { desc = "Toggle linting" })
		end,
	},
}
