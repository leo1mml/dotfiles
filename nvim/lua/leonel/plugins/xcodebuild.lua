local progress_handle

-- Function to check if the current directory is an Xcode project
local function is_xcode_project_dir()
    local cwd = vim.fn.getcwd()
    local xcodeproj = vim.fn.globpath(cwd, "*.xcodeproj", 0, 1)
    local xcworkspace = vim.fn.globpath(cwd, "*.xcworkspace", 0, 1)
    local swift = vim.fn.globpath(cwd, "*.swift", 0, 1)

    return (#xcodeproj > 0 or #xcworkspace > 0 or #swift > 0)
end

return {
    "wojciech-kulik/xcodebuild.nvim",
    -- Use 'cond' for conditional loading.
    -- Make sure 'is_xcode_project_dir()' explicitly returns Lua true/false.
    cond = is_xcode_project_dir(),
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
        "nvim-tree/nvim-tree.lua",         -- (optional) to manage project files
        "stevearc/oil.nvim",               -- (optional) to manage project files
        "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
        "folke/trouble.nvim",
    },
    config = function()
        -- The rest of your configuration remains the same
        require("xcodebuild").setup({
            code_coverage = {
                enabled = true,
            },
            integrations = {
                pymobiledevice = {
                    enabled = true,
                },
            },
        })

        -- stylua: ignore start
        vim.keymap.set("n", "<leader>XX", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
        vim.keymap.set("n", "<leader>Xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

        vim.keymap.set("n", "<leader>Xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
        vim.keymap.set("n", "<leader>XB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
        vim.keymap.set("n", "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

        vim.keymap.set("n", "<leader>Xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
        vim.keymap.set("v", "<leader>Xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
        vim.keymap.set("n", "<leader>XT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })

        vim.keymap.set("n", "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
        vim.keymap.set("n", "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
        vim.keymap.set("n", "<leader>XC", "<cmd>XcodebuildShowCodeCoverageReport<cr>",
            { desc = "Show Code Coverage Report" })
        vim.keymap.set("n", "<leader>Xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
        vim.keymap.set("n", "<leader>Xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

        vim.keymap.set("n", "<leader>XD", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
        vim.keymap.set("n", "<leader>Xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
        vim.keymap.set("n", "<leader>Xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

        vim.keymap.set("n", "<leader>Xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
        vim.keymap.set("n", "<leader>Xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })

        -- Debugger
        local xcodebuild = require("xcodebuild.integrations.dap")
        xcodebuild.setup()

        vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
        vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
        vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
        vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
        vim.keymap.set("n", "<leader>b", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
        vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })

        -- Trouble
        vim.api.nvim_create_autocmd("User", {
            pattern = { "XcodebuildBuildFinished", "XcodebuildTestsFinished" },
            callback = function(event)
                if event.data.cancelled then
                    return
                end

                if event.data.success then
                    require("trouble").close()
                elseif not event.data.failedCount or event.data.failedCount > 0 then
                    if next(vim.fn.getqflist()) then
                        require("trouble").open("quickfix")
                    else
                        require("trouble").close()
                    end

                    require("trouble").refresh()
                end
            end,
        })
    end,
}
