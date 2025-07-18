return {
	-- Ensure mason-lspconfig.nvim is listed only once
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
		"neovim/nvim-lspconfig",
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		},
		-- "williamboman/mason-lspconfig.nvim", -- Removed duplicate entry
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		"L3MON4D3/LuaSnip",
		"Hoffs/omnisharp-extended-lsp.nvim",
	},
	config = function()
		local mason = require("mason")
		mason.setup()

		local masonlspconfig = require("mason-lspconfig")
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Define a common on_attach function for all LSP servers
		local on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, remap = false }

			local keymap = vim.keymap
			-- Keymaps for LSP functionalities

			opts.desc = "Go to implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

			opts.desc = "Go to type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

			opts.desc = "Go to Telescope diagnostics for buffer"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
		end

		-- Used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Configure mason-lspconfig to ensure installation of desired servers
		masonlspconfig.setup({
			ensure_installed = { "lua_ls", "omnisharp" }, -- Include all LSPs you want Mason to manage
			automatic_installation = true,
			-- The 'handlers' table is removed as it's no longer supported.
			-- Server-specific configurations are now done directly via lspconfig.setup().
		})


		--- LSP Server Configurations ---
		-- Configure sourcekit
		lspconfig.sourcekit.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "swift", "objc", "m", "h" },
			-- Assuming 'lsp' variable is defined elsewhere if needed for cmd logic,
			-- otherwise, simplify or define 'lsp' here.
			-- For this example, assuming sourcekit-lsp is in PATH or xcrun handles it.
			cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
		})

		-- Configure gdscript
		lspconfig.gdscript.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- Call the common on_attach first
				on_attach(client, bufnr)
				-- Add gdscript-specific on_attach logic
				local _notify = client.notify
				client.notify = function(method, params)
					if method == "textDocument/didClose" then
						-- Godot doesn't implement didClose yet
						return
					end
					_notify(method, params)
				end
			end,
		})

		vim.g.rustaceanvim = function()
			-- Update this path
			local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
			local codelldb_path = extension_path .. 'adapter/codelldb'
			local liblldb_path = extension_path .. 'lldb/lib/liblldb'
			local this_os = vim.uv.os_uname().sysname;

			-- The path is different on Windows
			if this_os:find "Windows" then
				codelldb_path = extension_path .. "adapter\\codelldb.exe"
				liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
			else
				-- The liblldb extension is .so for Linux and .dylib for MacOS
				liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
			end

			local cfg = require('rustaceanvim.config')
			return {
				server = {
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
					end,
					default_settings = {
						-- rust-analyzer language server configuration
						['rust-analyzer'] = {
						},
					},
				},
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
			}
		end
	end,
}
