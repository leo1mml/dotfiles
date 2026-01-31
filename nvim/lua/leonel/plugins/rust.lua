return {
	-- Extend auto-completion for crates.nvim
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = { enabled = true },
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},

	-- Add Rust to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "rust", "ron" } },
	},

	-- Configure rustaceanvim
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		ft = { "rust" },
		opts = {
			server = {
				on_attach = function(_, bufnr)
					-- Mirror LazyVim's specific Rust keymaps
					vim.keymap.set("n", "<leader>cR", function()
						vim.cmd.RustLsp("codeAction")
					end, { desc = "Code Action", buffer = bufnr })
					vim.keymap.set("n", "<leader>dr", function()
						vim.cmd.RustLsp("debuggables")
					end, { desc = "Rust Debuggables", buffer = bufnr })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = { enable = true },
						},
						-- Add clippy lints on save
						checkOnSave = true,
						procMacro = { enable = true },
						files = {
							exclude = { ".direnv", ".git", "target" },
						},
					},
				},
			},
		},
		config = function(_, opts)
			-- Setup for Debugging (DAP)
			-- LazyVim looks for codelldb installed via Mason
			local package_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
			local codelldb_path = package_path .. "adapter/codelldb"
			local liblldb_path = package_path .. "lldb/lib/liblldb"
			local this_os = vim.uv.os_uname().sysname

			-- Adjust liblldb path based on OS
			if this_os:find("Windows") then
				liblldb_path = liblldb_path .. ".dll"
			elseif this_os:find("Darwin") then
				liblldb_path = liblldb_path .. ".dylib"
			else
				liblldb_path = liblldb_path .. ".so"
			end

			opts.dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
			}

			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		end,
	},

	-- Ensure debugger and LSP are installed via Mason
	{
		"williamboman/mason.nvim",
		optional = true,
		opts = { ensure_installed = { "codelldb" } },
	},
}
