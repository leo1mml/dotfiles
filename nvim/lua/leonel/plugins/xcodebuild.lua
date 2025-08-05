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
            show_build_progress_bar = false,
            logs = {
                notify = function(message, severity)
                    local fidget = require("fidget")
                    if progress_handle then
                        progress_handle.message = message
                        if not message:find("Loading") then
                            progress_handle:finish()
                            progress_handle = nil
                            if vim.trim(message) ~= "" then
                                fidget.notify(message, severity)
                            end
                        end
                    else
                        fidget.notify(message, severity)
                    end
                end,
                notify_progress = function(message)
                    local progress = require("fidget.progress")

                    if progress_handle then
                        progress_handle.title = ""
                        progress_handle.message = message
                    else
                        progress_handle = progress.handle.create({
                            message = message,
                            lsp_client = { name = "xcodebuild.nvim" },
                        })
                    end
                end,
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


        -- Xcode stuff
        local xcodebuild = require("xcodebuild.integrations.dap")

        -- TODO: change it to your local codelldb path
        local codelldbPath = "~/tools/codelldb-aarch64-darwin/extension/adapter/codelldb"

        xcodebuild.setup(codelldbPath)

        vim.keymap.set("n", "<leader>Xdd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
        vim.keymap.set("n", "<leader>Xdr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
        vim.keymap.set("n", "<leader>Xdt", xcodebuild.debug_tests, { desc = "Debug Tests" })
        vim.keymap.set("n", "<leader>XdT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
        vim.keymap.set("n", "<leader>Xdb", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>XdB", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
        vim.keymap.set("n", "<leader>Xdx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
    end,
}
