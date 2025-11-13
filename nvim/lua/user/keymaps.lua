local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Require plugin modules
local custom_functions = require("user.custom_functions")

-- General Utility
keymap("i", "<leader>q", "<Esc>", { noremap = true, desc = "Exit insert mode" })
keymap("v", "<leader>q", "<Esc>", { noremap = true, desc = "Exit insert mode" })
keymap("n", "<F4>", ":set hlsearch! hlsearch?<CR>", opts)
keymap("n", "<F5>", [[:let _s=@/ | %s/\s\+$//e | let @/=_s | redraw! | echo "Removed trailing spaces"<CR>]], opts)
keymap("n", "<leader>n", "s<CR>", { noremap = true, desc = "Break line at cursor" })
keymap(
	"n",
	"<leader>sc",
	custom_functions.snake_case_names,
	{ noremap = true, silent = true, desc = "Convert value of field to snake_case" }
)

keymap("n", "<leader>r", ":set relativenumber!<CR>", { desc = "Toggle relative number lines" })
keymap("n", "<leader>vv", "<C-v>", { desc = "Visual Vertical Mode" })
keymap("n", "<leader>p", '"_dP', { desc = "Paste to replace without overwriting register" })

-- Window & Pane Navigation
keymap("n", "<leader>h", "<C-w>h", { desc = "Navigate Left" })
keymap("n", "<leader>l", "<C-w>l", { desc = "Navigate Right" })
keymap("n", "<leader>k", "<C-w>k", { desc = "Navigate Up" })
keymap("n", "<leader>j", "<C-w>j", { desc = "Navigate Down" })

-- File Explorer
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap("n", "<leader>ee", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Diagnostics
keymap("n", "<leader>kk", vim.diagnostic.open_float, { desc = "Open diagnostic float" }) -- Note: LSP hover may override this

-- Copilot
keymap("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
keymap("n", "<leader>za", "<cmd>CopilotChat<CR>", { desc = "Open Copilot Chat" })
keymap("v", "<leader>za", "<cmd>CopilotChat<CR>", { desc = "Open Copilot Chat" })
keymap("v", "<leader>ze", "<cmd>CopilotChatExplain<CR>", { desc = "Explain Code" })
keymap("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat - Explain code" })
keymap("v", "<leader>zr", "<cmd>CopilotChatReview<CR>", { desc = "Review Code" })
keymap("v", "<leader>zf", "<cmd>CopilotChatFix<CR>", { desc = "Fix Code" })
keymap("v", "<leader>zo", "<cmd>CopilotChatOptimize<CR>", { desc = "Optimise Code" })
keymap("v", "<leader>zt", "<cmd>CopilotChatTests<CR>", { desc = "Generate Tests" })
keymap("n", "<leader>zm", "<cmd>CopilotChatCommit<CR>", { desc = "Generate Commit Message" })
keymap("v", "<leader>zs", "<cmd>CopilotChatCommit<CR>", { desc = "Generate Commit for Selection" })
