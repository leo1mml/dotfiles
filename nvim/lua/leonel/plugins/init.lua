return {
    'christoomey/vim-tmux-navigator',
    'habamax/vim-godot',
    'tpope/vim-surround',
    'Townk/vim-autoclose',
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    'tpope/vim-sleuth',-- Detect tabstop and shiftwidth automatically
    'theHamsta/nvim-dap-virtual-text',-- Show DAP messages in virtual text
    'nvim-telescope/telescope-dap.nvim',-- Telescope integration for nvim-dap', 
    -- Fuzzy Finder (files, lsp, etc)
    {
        -- install without yarn or npm
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,

    },
}
