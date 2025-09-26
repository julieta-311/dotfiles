return {
  -- File Explorer.
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
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
    end,
  },

  -- Seamless navigation between tmux and vim splits.
  { "christoomey/vim-tmux-navigator" },

  {
    "fatih/vim-go",
    dependencies = { "lewis6991/gitsigns.nvim" }, -- Example: if it has dependencies
    init = function()
      -- Set golangci-lint as the linter
      vim.g.go_lint_tool = "golangci-lint"

      -- Enable running the linter on save
      vim.g.go_lint_autosave = 1
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
    -- Setup completion.
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      })
    })

    -- 1. Create a global autocommand for LSP keymaps
    -- This defines keymaps for ALL language servers in one place.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })

    vim.lsp.config.setup('gopls', {}) 
    -- lspconfig.gopls.setup({})
    -- lspconfig.pyright.setup({}) -- When adding more, they go here.
    -- lspconfig.tsserver.setup({})
    -- lspconfig.clojure_lsp.setup({})

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
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
      })
    end,
  },

  -- Autoformatter.
  { "prettier/vim-prettier" },

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
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper.
    },
    opts = {
      debug = false, -- Enable debug logging.
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
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Next Git hunk" })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Previous Git hunk" })

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage Git hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Git hunk" })
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Stage selected lines" })
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Reset selected lines" })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Git blame line" })
        end
      })
    end,
  },
}
