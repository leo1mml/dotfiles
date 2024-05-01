return {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/notes/personal",
                            work = "~/notes/work",
                        },
                    },
                },
            },
        }

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
    end,

}
