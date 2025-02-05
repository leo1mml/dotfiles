return {
	"williamboman/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"mrcjkb/rustaceanvim",
			version = "^5", -- Recommended
			lazy = false, -- This plugin is already lazy
		},
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
		"neovim/nvim-lspconfig",
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		},
		"williamboman/mason-lspconfig.nvim",
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

		local on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, remap = false }
			opts.desc = "Go to definition"
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Workspace symbol"
			vim.keymap.set("n", "<leader>ws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)

			opts.desc = "Code Action"
			vim.keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, opts)

			opts.desc = "Go to references"
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Rename"
			vim.keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)

			opts.desc = "Signature Help"
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)

			opts.desc = "Go to implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Go to type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "Go to Telescope diagnostics for buffer"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

			-- rustaceanvim
			opts.desc = "Rust Tests"
			keymap.set("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		lspconfig.sourcekit.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "swift", "objc", "m", "h" },
		})

		lspconfig.gdscript.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
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

		masonlspconfig.setup({
			ensure_installed = { "rust_analyzer", "lua_ls" },
			automatic_installation = true,
			handlers = {
				function(server_name) -- default handler (optional)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
				-- Next, you can provide targeted overrides for specific servers.
				["rust_analyzer"] = function()
					local mason_registry = require("mason-registry")

					local codelldb = mason_registry.get_package("codelldb")
					local extension_path = codelldb:get_install_path() .. "/extension/"
					local codelldb_path = extension_path .. "adapter/codelldb"
					local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

					vim.g.rustaceanvim = function()
						local cfg = require("rustaceanvim.config")
						return {
							server = {
								on_attach = on_attach,
								capabilities = capabilities,
							},
							dap = {
								adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
							},
						}
					end
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["omnisharp"] = function()
					lspconfig.omnisharp.setup({
						cmd = {
							"omnisharp",
							"--languageserver",
							"--hostPID",
							tostring(vim.fn.getpid()),
						},
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							RoslynExtensionsOptions = {
								enableDecompilationSupport = false,
								enableImportCompletion = true,
								enableAnalyzersSupport = true,
							},
						},
						root_dir = lspconfig.util.root_pattern("*.sln"),
						handlers = {
							["textDocument/definition"] = require("omnisharp_extended").definition_handler,
							["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
							["textDocument/references"] = require("omnisharp_extended").references_handler,
							["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
						},
					})
				end,
			},
		})
		vim.diagnostic.config({
			virtual_text = true,
		})
	end,
}
