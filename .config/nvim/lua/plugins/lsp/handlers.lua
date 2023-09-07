local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		-- virtual_text = {
		-- 	spacing = 2,
		-- 	severity = {
		-- 		min = vim.diagnostic.severity.INFO,
		-- 	},
		-- },
		-- show signs
		signs = {
			active = signs,
			severity = {
				min = vim.diagnostic.severity.INFO,
			},
		},
		-- update_in_insert = true,
		-- underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
			wrap_at = 35,
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		width = 60,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		width = 60,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
M.on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end

	local opts = { noremap = true, silent = true }

	local function buf_set_keymap(mode, mapping, command)
		vim.api.nvim_buf_set_keymap(bufnr, mode, mapping, command, opts)
	end

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	buf_set_keymap("n", "<leader>d", "<cmd> lua vim.lsp.buf.definition()<CR>")
	buf_set_keymap("n", "<leader>i", "<cmd> lua vim.lsp.buf.implementation()<CR>")
	-- Handled by telescope.
	-- buf_set_keymap('n', '<leader>r', '<cmd> lua vim.lsp.buf.references()<CR>')
	buf_set_keymap("i", "<C-k>", "<cmd> lua vim.lsp.buf.signature_help()<CR>")
	buf_set_keymap("n", "<leader>k", "<cmd> lua vim.lsp.buf.hover()<CR>")
	buf_set_keymap("n", "<leader>e", "<cmd> lua vim.diagnostic.goto_next()<CR>")
	buf_set_keymap("n", "<leader>E", "<cmd> lua vim.diagnostic.goto_prev()<CR>")
	buf_set_keymap("n", "<leader>u", "<cmd> lua vim.lsp.buf.incoming_calls()<CR>")
	buf_set_keymap("n", "<leader>U", "<cmd> lua vim.lsp.buf.outgoing_calls()<CR>")
	buf_set_keymap("n", "<leader>R", "<cmd> lua vim.lsp.buf.rename()<CR>")
	buf_set_keymap("n", "<leader>ca", "<cmd> lua vim.lsp.buf.code_action()<CR>")
end

return M
