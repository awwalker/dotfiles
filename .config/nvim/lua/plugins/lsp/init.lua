local M = {
	{
		"neovim/nvim-lspconfig",
		event = "BufRead",
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
				settings = require("plugins.lsp.clojure").lsp,
			})

			lsp.dockerls.setup({
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities(),
				settings = require("plugins.lsp.docker").lsp,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "BufRead",
		config = function()
			local nls = require("null-ls")
			local handlers = require("plugins.lsp.handlers")

			nls.setup({
				debug = true,
				debounce = 150,
				save_after_format = false,
				on_attach = handlers.on_attach,
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
				sources = {
					-- DOCKER
					nls.builtins.diagnostics.hadolint.with(require("plugins.lsp.docker").nls),
					-- LUA
					nls.builtins.formatting.stylua,
				},
			})
		end,
	},
}

return M
