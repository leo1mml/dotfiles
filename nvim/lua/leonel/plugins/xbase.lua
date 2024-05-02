return {
    'xbase-lab/xbase',
    build = 'make install', -- or "make install && make free_space" (not recommended, longer build time)
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
        local xbase = require("xbase")
        xbase.setup({
            simctl = {
                iOS = {
                    "iPhone 15 Pro", --- only use this devices
                },
                watchOS = {},        -- all available devices
                tvOS = {},           -- all available devices
            },
            mappings = {
                --- Whether xbase mapping should be disabled.
                enable = true,
                --- Open build picker. showing targets and configuration.
                build_picker = "<leader>xb", --- set to 0 to disable
                --- Open run picker. showing targets, devices and configuration
                run_picker = "<leader>xr",   --- set to 0 to disable
                --- Open watch picker. showing run or build, targets, devices and configuration
                watch_picker = "<leader>xw", --- set to 0 to disable
                --- A list of all the previous pickers
                all_picker = "<leader>xp",   --- set to 0 to disable
                --- vertical toggle log buffer
                toggle_vsplit_log_buffer = "<leader>lv",
            },
        }) -- see default configuration bellow
    end
}
