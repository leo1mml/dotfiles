return {
    'nvimdev/lspsaga.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('lspsaga').setup({
            hover = {
                max_width = 0.5,
            }
        })
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons'      -- optional
    }
}
