-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
return {
    "VonHeikemen/lsp-zero.nvim",
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate" -- :MasonUpdate updates registry contents
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional
        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    },
    config = function()
        local lsp = require("lsp-zero")
        local servers = {'clangd', 'rust_analyzer', 'pyright', 'tsserver', 'lua_ls'}

        lsp.preset("recommended")

        lsp.ensure_installed(servers)

        lsp.configure('glslls', {})

        -- Fix Undefined global 'vim'
        lsp.configure('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
        })

        lsp.configure('sourcekit', {
            cmd = { 'xcrun', 'sourcekit-lsp' },
            filetypes = { 'swift' },
        })

        lsp.configure('gdscript')

        lsp.configure('rust_analyzer', {
            cmd = {
                "rustup", "run", "stable", "rust-analyzer"
            }
        })

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = true,
        })

    end
}
