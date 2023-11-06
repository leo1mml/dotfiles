return {
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    flavor = "macchiato",
    term_colors = true,
    transparent_background = true,
    config = function()
        vim.cmd.colorscheme "catppuccin"
    end,
}
