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
			local blink = require("blink.cmp")
			local capabilities = blink.get_lsp_capabilities()
			vim.lsp.log.set_level("error")

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

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = require("plugins.lsp.lua").lsp,
			})

			vim.lsp.config("clojure_lsp", {
				filetypes = { "clojure", "edn" },
				root_markers = { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git" },
			})

			vim.lsp.config("fennel_language_server", {
				root_markers = { "fnl", "lua" },
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

			vim.lsp.enable({
				"lua_ls",
				"clojure_lsp",
				"dockerls",
				"jsonls",
				"marksman",
				"pyright",
				"cssmodules_ls",
				"ts_ls",
				"terraformls",
				"fennel_language_server",
				"lemminx",
				"pylsp",
			})
		end,
	},
	require("plugins.lsp.conform"),
}

return M
