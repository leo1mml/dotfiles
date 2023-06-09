-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local lsp = require("lsp-zero")
local servers = { 'clangd','omnisharp', 'rust_analyzer', 'pyright', 'tsserver', 'lua_ls'}

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

lsp.configure('rust_analyzer', {
    cmd = {
        "rustup", "run", "stable", "rust-analyzer"
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})
-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
