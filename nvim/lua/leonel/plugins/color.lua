return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
    },
    config = function()
        require("tokyonight").setup({
            style = "storm",
            terminal_colors = true,
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        })
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
        vim.cmd.colorscheme "tokyonight"
    end,
}
