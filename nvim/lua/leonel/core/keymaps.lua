-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.godot_executable = '/usr/bin/godot-mono'

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', "<leader>rr", "<cmd>Ex<CR>")

-- Default remapping
vim.keymap.set("n", "gd", "<C-]>", { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = true,
  },
  signs = true,
  underline = true,
})

-- Window resizing
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>')
