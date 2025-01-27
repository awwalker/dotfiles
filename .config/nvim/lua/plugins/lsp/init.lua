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
			local cmp_nvim = require("cmp_nvim_lsp")
			local lspconfig_defaults = require("lspconfig").util.default_config
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				lspconfig_defaults.capabilities,
				vim.lsp.protocol.make_client_capabilities(),
				cmp_nvim.default_capabilities()
			)
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
				width = 80,
			})
			-- no lag.
			-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
			-- insane lag.
			-- vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {})
			vim.lsp.set_log_level("error")

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "<leader>d", "<cmd> lua vim.lsp.buf.definition()<CR>", opts)
					vim.keymap.set("n", "<leader>i", "<cmd> lua vim.lsp.buf.implementation()<CR>", opts)
					vim.keymap.set("n", "<C-k>", "<cmd> lua vim.lsp.buf.signature_help()<CR>", opts)
					vim.keymap.set("n", "<leader>k", "<cmd> lua vim.lsp.buf.hover()<CR>", opts)
					vim.keymap.set("n", "<leader>e", "<cmd> lua vim.diagnostic.jump({count = 1})<CR>", opts)
					vim.keymap.set("n", "<leader>E", "<cmd> lua vim.diagnostic.jump({count = -1})<CR>", opts)
					vim.keymap.set("n", "<leader>u", "<cmd> lua vim.lsp.buf.incoming_calls()<CR>", opts)
					vim.keymap.set("n", "<leader>U", "<cmd> lua vim.lsp.buf.outgoing_calls()<CR>", opts)
					vim.keymap.set("n", "<leader>R", "<cmd> lua vim.lsp.buf.rename()<CR>", opts)
					vim.keymap.set("n", "<leader>ca", "<cmd> lua vim.lsp.buf.code_action()<CR>", opts)
				end,
			})

			lsp.lua_ls.setup({
				settings = require("plugins.lsp.lua").lsp,
				capabilities = capabilities,
			})

			lsp.clojure_lsp.setup({
				filetypes = { "clojure", "edn" },
				root_dir = lsp.util.root_pattern("project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git"),
				capabilities = capabilities,
			})

			lsp.dockerls.setup({
				capabilities = capabilities,
			})

			lsp.jsonls.setup({
				capabilities = capabilities,
			})

			lsp.marksman.setup({
				capabilities = capabilities,
			})

			lsp.pyright.setup({
				capabilities = capabilities,
			})

			lsp.cssmodules_ls.setup({
				capabilities = capabilities,
			})

			lsp.ts_ls.setup({
				capabilities = capabilities,
			})
		end,
	},
	-- require("plugins.lsp.linting"),
	require("plugins.lsp.conform"),
}

return M
