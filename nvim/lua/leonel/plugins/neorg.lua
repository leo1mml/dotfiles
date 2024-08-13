return {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    keys = {
        { "<Leader>nt", "<cmd>Neorg journal today<cr>",  { desc = "Today personal note" } },
        { "<Leader>nC", "<cmd>Neorg journal custom<cr>", { desc = "Select date personal note" } },
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
