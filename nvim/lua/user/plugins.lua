return {
	{
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>tf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>tg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
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
        signs =true,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
      })

      local lspconfig = require("lspconfig")

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

			lspconfig.gopls.setup({})
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized client identifier.
						telemetry = {
							enable = false,
						},
					},
				},
			})
			lspconfig.pyright.setup({})
			lspconfig.tsserver.setup({})
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
		config = function()
			require("bufferline").setup({
				options = {
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
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "Harpoon: Add file" })
			vim.keymap.set("n", "<leader>hh", ui.toggle_quick_menu, { desc = "Harpoon: Toggle menu" })
			vim.keymap.set("n", "<leader>h1", function() ui.nav_file(1) end, { desc = "Harpoon: Navigate to file 1" })
			vim.keymap.set("n", "<leader>h2", function() ui.nav_file(2) end, { desc = "Harpoon: Navigate to file 2" })
			vim.keymap.set("n", "<leader>h3", function() ui.nav_file(3) end, { desc = "Harpoon: Navigate to file 3" })
			vim.keymap.set("n", "<leader>h4", function() ui.nav_file(4) end, { desc = "Harpoon: Navigate to file 4" })
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
