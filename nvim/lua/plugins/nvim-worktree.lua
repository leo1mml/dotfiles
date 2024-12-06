return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
  },
  config = function()
    require('telescope').load_extension('git_worktree')
    vim.keymap.set('n', '<leader>gt', "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
      { desc = '[S]earch [T]rees' })
    vim.keymap.set('n', '<leader>gT', "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
      { desc = 'Create Tree' })
  end
}
