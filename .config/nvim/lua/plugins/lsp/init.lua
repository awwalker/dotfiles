local M = {
	{
		"neovim/nvim-lspconfig",
		event = { "BufRead", "BufWritePre", "BufReadPre", "InsertEnter" },
		keys = {
			{ "<leader>d", mode = "n" },
			{ "<leader>i", mode = "n" },
			{ "<leader>k", mode = "n" },
			{ "<leader>e", mode = "n" },
			{ "<leader>E", mode = "n" },
			{ "<leader>u", mode = "n" },
			{ "<leader>U", mode = "n" },
			{ "<leader>R", mode = "n" },
			{ "<leader>ca", mode = "n" },
		},
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lsp = require("lspconfig")
			local util = require("lspconfig.util")
			local handlers = require("plugins.lsp.handlers")
			local cmp_nvim = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim.default_capabilities(vim.lsp.protocol.make_client_capabilities())

			lsp.sumneko_lua.setup({
				on_attach = handlers.on_attach,
				capabilities = capabilities,
				single_file_support = true,
				settings = require("plugins.lsp.lua").lsp,
			})

			lsp.clojure_lsp.setup({
				on_attach = handlers.on_attach,
				capabilities = capabilities,
				root_dir = util.root_pattern("project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git"),
			})

			lsp.dockerls.setup({
				on_attach = handlers.on_attach,
				capabilities = capabilities,
			})

			lsp.jsonls.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.document_formatting = false
					handlers.on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				settings = {
					{
						init_options = {
							provideFormatter = false,
						},
					},
				},
			})

			lsp.marksman.setup({
				on_attach = handlers.on_attach,
				capabilities = capabilities,
			})

			lsp.pyright.setup({
				on_attach = handlers.on_attach,
				capabilities = capabilities,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufRead", "BufWritePre" },
		config = function()
			local nls = require("null-ls")
			local handlers = require("plugins.lsp.handlers")
			local cmp_nvim = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim.default_capabilities(vim.lsp.protocol.make_client_capabilities())

			nls.setup({
				debug = true,
				debounce = 150,
				save_after_format = false,
				on_attach = handlers.on_attach,
				capabilities = capabilities,
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
				sources = {
					-- DOCKER
					nls.builtins.diagnostics.hadolint.with(require("plugins.lsp.docker").nls),
					-- JSON
					nls.builtins.formatting.prettier.with(require("plugins.lsp.prettier").json),
					-- LUA
					nls.builtins.formatting.stylua,
					-- MARKDOWN
					nls.builtins.diagnostics.markdownlint,
					nls.builtins.formatting.prettier.with(require("plugins.lsp.prettier").md),
					-- nls.builtins.formatting.markdownlint, Use Prettier instead.
					-- XML
					nls.builtins.diagnostics.tidy,
					-- nls.builtins.formatting.tidy,
					-- WHITESPACE
					nls.builtins.diagnostics.trail_space,
					nls.builtins.formatting.trim_whitespace,
					nls.builtins.formatting.trim_newlines,
				},
			})
		end,
	},
}

return M
