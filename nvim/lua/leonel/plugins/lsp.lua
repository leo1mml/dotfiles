return {
	-- Ensure mason-lspconfig.nvim is listed only once
	"williamboman/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"mrcjkb/rustaceanvim",
			version = "^6", -- Recommended
			lazy = false, -- This plugin is already lazy
		},
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
		local keymap = vim.keymap -- for conciseness

		-- Define a common on_attach function for all LSP servers
		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }

			-- Keymaps for LSP functionalities
			opts.desc = "Go to definition"
			keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			opts.desc = "Workspace symbol"
			keymap.set("n", "<leader>ws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)

			opts.desc = "Code Action"
			keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, opts)

			opts.desc = "Go to references"
			keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Rename"
			keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)

			opts.desc = "Signature Help"
			keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)

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

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover)

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

			-- Rustaceanvim specific keymap (if rust_analyzer is attached)
			if client.name == "rust_analyzer" then
				opts.desc = "Rust Tests"
				keymap.set("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", opts)
			end
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
			ensure_installed = { "rust_analyzer", "lua_ls", "omnisharp", "sourcekit", "gdscript" }, -- Include all LSPs you want Mason to manage
			automatic_installation = true,
			-- The 'handlers' table is removed as it's no longer supported.
			-- Server-specific configurations are now done directly via lspconfig.setup().
		})

		-- --- LSP Server Configurations ---
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

		-- Configure rust_analyzer
		-- Rustaceanvim handles the rust_analyzer setup internally,
		-- but you can still pass common capabilities and on_attach.
		-- The rustaceanvim configuration below will override/extend this.
		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
			on_attach = on_attach, -- Use the common on_attach
			-- You can add any general rust_analyzer settings here if not handled by rustaceanvim
		})

		-- Rustaceanvim specific configuration
		-- This block now directly sets vim.g.rustaceanvim by calling the function
		vim.g.rustaceanvim = (function() -- Immediately invoke the function
			local mason_registry = require("mason-registry")
			local codelldb = mason_registry.get_package("codelldb")
			local extension_path = codelldb:get_install_path() .. "/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
			local cfg = require("rustaceanvim.config") -- Ensure this is required if used

			return {
				-- Plugin configuration
				tools = {
					-- Add any Rustaceanvim tool configurations here
				},
				-- LSP configuration for rust_analyzer
				server = {
					-- This on_attach will be specifically for rust_analyzer
					on_attach = function(client, bufnr)
						-- Call your global on_attach if you want all common keymaps
						on_attach(client, bufnr)

						-- Add or re-emphasize Rust-specific keymaps here if needed
						local opts = { buffer = bufnr, remap = false }
						opts.desc = "Code Action (Rust)"
						vim.keymap.set("n", "<leader>ca", function()
							vim.cmd.RustLsp('codeAction')
						end, opts)

						-- The Rust Tests keymap is already in the common on_attach,
						-- but you can put it here if you want it *only* for Rust.
						-- opts.desc = "Rust Tests"
						-- keymap.set("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", opts)
					end,
					capabilities = capabilities,
					default_settings = {
						-- rust-analyzer language server configuration
						['rust-analyzer'] = {
							-- specific rust-analyzer settings
							check = {
								command = "clippy", -- Example: use clippy for checks
							},
						},
					},
				},
				-- DAP configuration for Rust
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
			}
		end)() -- Immediately invoke the function with ()
		-- End of Rustaceanvim specific configuration

		-- Configure lua_ls
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach, -- Attach the common on_attach
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false, -- Example: disable checking third-party Lua files
					},
					telemetry = {
						enable = false, -- Example: disable telemetry
					},
				},
			},
		})

		-- Configure omnisharp
		lspconfig.omnisharp.setup({
			cmd = {
				"omnisharp",
				"--languageserver",
				"--hostPID",
				tostring(vim.fn.getpid()),
			},
			capabilities = capabilities,
			on_attach = on_attach, -- Attach the common on_attach
			settings = {
				RoslynExtensionsOptions = {
					enableDecompilationSupport = false,
					enableImportCompletion = true,
					enableAnalyzersSupport = true,
				},
			},
			root_dir = lspconfig.util.root_pattern("*.sln", ".git", "omnisharp.json"), -- Added more root patterns
			-- Handlers for omnisharp_extended are still valid as they are specific to that plugin's integration,
			-- not mason-lspconfig's global handlers.
			handlers = {
				["textDocument/definition"] = require("omnisharp_extended").definition_handler,
				["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
				["textDocument/references"] = require("omnisharp_extended").references_handler,
				["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
			},
		})

		-- Global diagnostic configuration
		vim.diagnostic.config({
			virtual_text = true,
			-- You might want to add other diagnostic settings here, e.g.,
			-- signs = true,
			-- update_in_insert = false,
			-- float = {
			--     focusable = false,
			--     style = "minimal",
			--     border = "rounded",
			--     source = "always",
			--     header = "",
			--     prefix = "",
			-- },
		})
	end,
}
