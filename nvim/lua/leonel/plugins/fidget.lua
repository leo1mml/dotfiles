return {
	"j-hui/fidget.nvim",
	event = "LspAttach", -- Changed from VeryLazy to fire exactly when LSP starts
	opts = {
		-- Progress: The "fidgeting" spinner for LSP status
		progress = {
			poll_rate = 0, -- How and when to poll for progress messages
			suppress_on_insert = true, -- Don't flicker while you're typing
			ignore_done_already = true, -- Ignore completed tasks on startup
			display = {
				render_limit = 5, -- Max number of tasks to show at once
				done_ttl = 3, -- How long to show "Done" (seconds)
			},
		},

		-- Notification: The toast-style alerts
		notification = {
			poll_rate = 10, -- How frequently to update and render notifications
			filter = vim.log.levels.INFO, -- Minimum log level (INFO, WARN, ERROR)
			history_size = 128, -- Number of notifications to keep in history
			override_vim_notify = true, -- Automatically redirect vim.notify() to Fidget
			window = {
				normal_hl = "Comment", -- More subtle than "String"
				winblend = 10, -- Slight transparency for a modern look
				border = "rounded",
				zindex = 45,
				max_width = 0,
				max_height = 0,
				x_padding = 1,
				y_padding = 0,
				align = "bottom",
				relative = "editor",
			},
		},
	},
}
