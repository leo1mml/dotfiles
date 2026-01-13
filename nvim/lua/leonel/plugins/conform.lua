return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>fb",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
				vim.notify("Formatted buffer")
			end,
			mode = "",
			desc = "Format buffer",
		},
		{
			"<leader>tf",
			function()
				-- If autoformat is currently disabled for this buffer,
				-- then enable it, otherwise disable it
				if vim.b.disable_autoformat then
					vim.cmd("FormatEnable")
					vim.notify("Enabled autoformat for current buffer")
				else
					vim.cmd("FormatDisable!")
					vim.notify("Disabled autoformat for current buffer")
				end
			end,
			desc = "Toggle autoformat for current buffer",
		},
		{
			"<leader>tF",
			function()
				-- If autoformat is currently disabled globally,
				-- then enable it globally, otherwise disable it globally
				if vim.g.disable_autoformat then
					vim.cmd("FormatEnable")
					vim.notify("Enabled autoformat globally")
				else
					vim.cmd("FormatDisable")
					vim.notify("Disabled autoformat globally")
				end
			end,
			desc = "Toggle autoformat globally",
		},
		{
			"<leader>fd",
			function()
				vim.cmd("DiffFormat")
				vim.notify("Formatted diffs")
			end,
			desc = "Format diffs",
		},
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true }, -- Corrected line
			rust = { "rustfmt" },
			csharp = { "csharpier" },
			objectivec = { "uncrustify" },
			swift = { "swiftformat" },
		},
		-- Set up format-on-save
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			local disable_filetypes = { c = false, cpp = false }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		-- Customize formatters
		formatters = {
			swiftformat = {
				command = "swiftformat",
				args = { '--disable', 'trailingCommas, wrapMultilineStatementBraces, sortImports, unusedArguments, spaceAroundOperators', '--stdinpath', '$FILENAME' },
				stdin = true,
			},
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- :FormatDisable! disables autoformat for this buffer only
				vim.b.disable_autoformat = true
			else
				-- :FormatDisable disables autoformat globally
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true, -- allows the ! variant
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.api.nvim_create_user_command("DiffFormat", function()
			local lines = vim.fn.system("git diff --unified=0"):gmatch("[^\n\r]+")
			local ranges = {}
			for line in lines do
				if line:find("^@@") then
					local line_nums = line:match("%+.- ")
					if line_nums:find(",") then
						local _, _, first, second = line_nums:find("(%d+),(%d+)")
						table.insert(ranges, {
							start = { tonumber(first), 0 },
							["end"] = { tonumber(first) + tonumber(second), 0 },
						})
					else
						local first = tonumber(line_nums:match("%d+"))
						table.insert(ranges, {
							start = { first, 0 },
							["end"] = { first + 1, 0 },
						})
					end
				end
			end
			local format = require("conform").format
			for _, range in pairs(ranges) do
				format({
					range = range,
				})
			end
		end, { desc = "Format changed lines" })
	end,
}
