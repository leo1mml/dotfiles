-- In your plugins specification file (e.g., lua/plugins/copilot.lua)
return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",   -- Lazy-load on insert mode entry
    build = ":Copilot auth", -- Automatically runs the auth command if not set up
    config = function()
        -- Disable inline suggestions and the panel to avoid conflicts with nvim-cmp
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
        })
    end
}
