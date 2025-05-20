return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.4',
  -- or                              , branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'ThePrimeagen/git-worktree.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'git_worktree')

    -- See `:help telescope.builtin`
    vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
    vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
    vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>st', "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
      { desc = '[S]earch [T]rees' })
    vim.keymap.set('n', '<leader>sT', "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
      { desc = 'Create Tree' })

    telescope.setup {
      find_files = {
        hidden = true
      },
      defaults = {
        path_display = { "smart" }
      }
    }
  end
}
