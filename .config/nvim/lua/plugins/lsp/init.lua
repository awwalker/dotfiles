local M = {
	{
		"neovim/nvim-lspconfig",
		event = { "BufRead", "BufWritePre" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lsp = require("lspconfig")
			local handlers = require("plugins.lsp.handlers")

			lsp.sumneko_lua.setup({
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities(),
				single_file_support = true,
				settings = require("plugins.lsp.lua").lsp,
			})

			lsp.clojure_lsp.setup({
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities(),
			})

			lsp.dockerls.setup({
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities(),
			})

			lsp.jsonls.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.document_formatting = false
					handlers.on_attach(client, bufnr)
				end,
				capabilities = handlers.capabilities(),
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
				capabilities = handlers.capabilities(),
			})

			lsp.python.setup({
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities(),
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

			nls.setup({
				debug = true,
				debounce = 150,
				save_after_format = false,
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities(),
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
				sources = {
					-- DOCKER
					nls.builtins.diagnostics.hadolint.with(require("plugins.lsp.docker").nls),
					-- JSON
					nls.builtins.formatting.prettier.with(require("plugins.lsp.json").nls),
					-- LUA
					nls.builtins.formatting.stylua,
					-- MARKDOWN
					nls.builtins.diagnostics.markdownlint,
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
