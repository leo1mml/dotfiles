return {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    lazy = false,
    verson = "9.0.0",
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.ui"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/notes/personal",
                            work = "~/notes/work",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        }

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2

        vim.keymap.set("n", "<leader>nt", "<cmd>Neorg journal today<CR>")    -- Open Today's Note
        vim.keymap.set("n", "<leader>nc", "<cmd>Neorg toggle-concealer<CR>") -- Open Neorg Calendar
        vim.keymap.set("n", "<leader>nC", "<cmd>Neorg journal custom<CR>")   -- Open Neorg Calendar
    end,

}
