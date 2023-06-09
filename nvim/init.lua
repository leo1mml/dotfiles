require("leonel.set")
require("leonel.remap")
-- Install packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'christoomey/vim-tmux-navigator',
  'simrat39/rust-tools.nvim',
  'habamax/vim-godot',
  'tpope/vim-surround',
  'Townk/vim-autoclose',
  'catppuccin/nvim',
  'github/copilot.vim',
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'}, -- Optional
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
    }
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true }
  },
  'lukas-reineke/indent-blankline.nvim',-- Add indentation guides even on blank lines
  'numToStr/Comment.nvim',-- "gc" to comment visual regions/lines
  'tpope/vim-sleuth',-- Detect tabstop and shiftwidth automatically
  -- Dap configuration
  'mfussenegger/nvim-dap',-- Debug Adapter protocol
  'rcarriga/nvim-dap-ui',-- UI for nvim-dap
  'theHamsta/nvim-dap-virtual-text',-- Show DAP messages in virtual text
  'nvim-telescope/telescope-dap.nvim',-- Telescope integration for nvim-dap', 
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim',} },
  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  'OmniSharp/omnisharp-vim',-- C# support
  {
    "glacambre/firenvim",
    cond = not not vim.g.started_by_firenvim,
    build = function()
        require("lazy").load({ plugins = "firenvim", wait = true })
        vim.fn["firenvim#install"](0)
    end,
  }
})
