local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Require plugin modules
local custom_functions = require("user.custom_functions")

-- Helper function to call the converter with a specific field name
local function convert_field(field_name)
	return function()
		require("user.custom_functions").convert_field_to_snake_case(field_name)
	end
end

keymap(
	"n",
	"<leader>sn",
	convert_field("name"),
	{ noremap = true, silent = true, desc = "Convert 'name' value to snake_case" }
)

keymap(
	"n",
	"<leader>sd",
	convert_field("desc"),
	{ noremap = true, silent = true, desc = "Convert 'desc' value to snake_case" }
)

-- General Utility
keymap("i", "<leader>q", "<Esc>", { noremap = true, desc = "Exit insert mode" })
keymap("v", "<leader>q", "<Esc>", { noremap = true, desc = "Exit insert mode" })
keymap("n", "<F4>", ":set hlsearch! hlsearch?<CR>", opts)
keymap("n", "<F5>", [[:let _s=@/ | %s/\s\+$//e | let @/=_s | redraw! | echo "Removed trailing spaces"<CR>]], opts)
keymap("n", "<leader>n", "s<CR><Esc>", { noremap = true, desc = "Break line at cursor" })

keymap("n", "<leader>r", ":set relativenumber!<CR>", { desc = "Toggle relative number lines" })
keymap("n", "<leader>vv", "<C-v>", { desc = "Visual Vertical Mode" })
keymap("n", "<leader>p", '"_dP', { desc = "Paste to replace without overwriting register" })

-- Window & Pane Navigation
keymap("n", "<leader>h", "<C-w>h", { desc = "Navigate Left" })
keymap("n", "<leader>l", "<C-w>l", { desc = "Navigate Right" })
keymap("n", "<leader>k", "<C-w>k", { desc = "Navigate Up" })
keymap("n", "<leader>j", "<C-w>j", { desc = "Navigate Down" })

-- File Explorer
keymap("n", "<leader>e", function()
	local api = require("nvim-tree.api")
	local current_buf = vim.api.nvim_buf_get_name(0)
	-- Default to current working directory if no file is open
	if current_buf == "" then
		api.tree.toggle()
		return
	end

	-- Calculate parent directory
	local current_dir = vim.fn.fnamemodify(current_buf, ":h")
	local parent_dir = vim.fn.fnamemodify(current_dir, ":h")

	-- Determine target: parent if valid, else current file's dir
	local target_dir = current_dir
	if vim.fn.isdirectory(parent_dir) == 1 then
		target_dir = parent_dir
	end

	-- Logic: If tree is visible, close it. If hidden, open at target.
	if api.tree.is_visible() then
		api.tree.close()
	else
		api.tree.open({ path = target_dir })
	end
end, { desc = "Toggle file explorer (Parent Dir)" })
keymap("n", "<leader>ee", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Diagnostics
keymap("n", "<leader>kk", vim.diagnostic.open_float, { desc = "Open diagnostic float" }) -- Note: LSP hover may override this

-- Copilot
keymap("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
keymap("v", "<leader>ca", "<cmd>CopilotChat<CR>", { desc = "Open Copilot Chat" })
keymap("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat - Explain code" })
keymap("v", "<leader>cr", "<cmd>CopilotChatReview<CR>", { desc = "Review Code" })
keymap("v", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "Fix Code" })
keymap("v", "<leader>co", "<cmd>CopilotChatOptimize<CR>", { desc = "Optimise Code" })
keymap("v", "<leader>ct", "<cmd>CopilotChatTests<CR>", { desc = "Generate Tests" })
keymap("n", "<leader>cm", "<cmd>CopilotChatCommit<CR>", { desc = "Generate Commit Message" })
keymap("v", "<leader>cs", "<cmd>CopilotChatCommit<CR>", { desc = "Generate Commit for Selection" })
