return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<Leader>nt", "<cmd>Neorg journal today<cr>" },
        { "<Leader>nC", "<cmd>Neorg journal custom<cr>" },
    },
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},  -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = {      -- Manages Neorg workspaces
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
    end,
}
