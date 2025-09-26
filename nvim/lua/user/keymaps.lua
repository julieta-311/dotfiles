local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Go to definition in a new tab or vertical split.
keymap("n", "<C-\\>", "<Cmd>tab split | exec('tag ' .. expand('<cword>'))<CR>", { remap = true })
keymap("n", "<A-]>", "<Cmd>vsp | exec('tag ' .. expand('<cword>'))<CR>", { remap = true })

-- Toggle search highlighting.
keymap("n", "<F4>", ":set hlsearch! hlsearch?<CR>", opts)

-- Remove trailing whitespace.
keymap("n", "<F5>", [[:let _s=@/ | %s/\s\+$//e | let @/=_s | redraw! | echo "Removed trailing spaces"<CR>]], opts)

-- Window navigation (for vim-tmux-navigator).
-- Note: The plugin often sets these up automatically, but this ensures they work.
keymap("n", "<c-h>", "<C-w>h", opts)
keymap("n", "<c-j>", "<C-w>j", opts)
keymap("n", "<c-k>", "<C-w>k", opts)
keymap("n", "<c-l>", "<C-w>l", opts)

-- Clipboard mappings.
-- Note: 'set clipboard=unnamedplus' usually makes these unnecessary, but here is the direct translation.
keymap("v", "<C-c>", '"+yi', { remap = true })
keymap("v", "<C-x>", '"+c', { remap = true })
keymap("v", "<C-v>", 'c<ESC>"+p', { remap = true })
keymap("i", "<C-v>", "<C-r><C-o>+", { remap = true })

-- Toggle NvimTree.
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

keymap("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })

-- In visual mode, select code and press ,ce to explain it
keymap("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat - Explain code" })
