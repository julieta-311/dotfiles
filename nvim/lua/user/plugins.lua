return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
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
					require("telescope.builtin").find_files({
						cwd = "/Users/julieta/ravelin/core",
					})
				end,
				desc = "Find files in core",
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
					dotfiles = true,
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local opts = { noremap = true, silent = true, buffer = bufnr }

					-- Open files in new splits
					vim.keymap.set("n", "h", api.node.open.horizontal, opts)
					vim.keymap.set("n", "s", api.node.open.vertical, opts)
				end,
				actions = {
					open_file = {
						quit_on_open = true,
						resize_window = true,
					},
				},
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
		"fatih/vim-go",
		dependencies = { "lewis6991/gitsigns.nvim" }, -- Example: if it has dependencies
		init = function()
			vim.g.go_def_mapping_enabled = 0 -- Let lsp handle this.
			vim.g.go_lint_tool = "golangci-lint"
			vim.g.go_lint_autosave = 1
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
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
				ensure_installed = { "go", "lua", "vim", "vimdoc" },

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
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})

			vim.lsp.enable("gopls")
			vim.lsp.enable("pyright")
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
					show_close_icon = "always",
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
			require("harpoon"):setup()

			vim.keymap.set("n", "<leader>ha", function()
				require("harpoon"):list():add()
			end)
			vim.keymap.set("n", "<leader>hh", function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end)

			vim.keymap.set("n", "<leader>h1", function()
				require("harpoon"):list():select(1)
			end)
			vim.keymap.set("n", "<leader>h2", function()
				require("harpoon"):list():select(2)
			end)
			vim.keymap.set("n", "<leader>h3", function()
				require("harpoon"):list():select(3)
			end)
			vim.keymap.set("n", "<leader>h4", function()
				require("harpoon"):list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				require("harpoon"):list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				require("harpoon"):list():next()
			end)

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
				-- The timeout for formatting on save, in milliseconds.
				timeout_ms = 500,
				-- Use LSP formatters if they are available.
				lsp_fallback = true,
			},

			-- A table of formatters.
			-- The key is the formatter name, and the value is the configuration.
			formatters_by_ft = {
				lua = { "stylua" },

				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				less = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },

				go = { "gofmt", "goimports" },
			},
		},
	},

	{
		"github/copilot.vim",
		config = function()
			-- Optional: Disable Copilot for certain filetypes
			vim.g.copilot_filetypes = {
				["*"] = true, -- Enable for all by default
				["help"] = false,
				["gitcommit"] = false,
				["gitrebase"] = false,
				["hgcommit"] = false,
				["svn"] = false,
				["cvs"] = false,
				[".md"] = false,
			}
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log and asyc functions.
		},
		opts = {
			debug = false,
			prompts = {
				Chat = {
					model = "gemini-2.5-pro", -- Google Gemini model name. See :h CopilotChat-models for available models.
					prompt = "You are a helpful AI coding assistant who is an expert in Golang. Provide clear, concise and idiomatic ansers to the user's questions, focusing on code-related topics. If you don't know the answer, just say that you don't know. Do not make up an answer.",
				},
			},
		},
	},

	-- Git integration.
	{ "tpope/vim-fugitive" },
	{ "tommcdo/vim-fugitive-blame-ext" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
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

					-- Actions
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
}
