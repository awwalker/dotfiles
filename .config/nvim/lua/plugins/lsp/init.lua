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
			"saghen/blink.cmp",
		},
		config = function()
			local lsp = require("lspconfig")
			local blink = require("blink.cmp")
			local capabilities = blink.get_lsp_capabilities()
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
			lsp.terraformls.setup({
				capabilities = capabilities,
			})
			lsp.fennel_language_server.setup({
				capabilities = capabilities,
				root_dir = lsp.util.root_pattern("fnl", "lua"),
				single_file_support = true,
				settings = {
					fennel = {
						diagnostics = {
							globals = { "vim", "jit", "comment" },
							workspace = {
								library = vim.env.VIMRUNTIME,
							},
						},
					},
				},
			})
		end,
	},
	require("plugins.lsp.conform"),
}

return M
