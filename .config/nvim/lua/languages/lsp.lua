local api = vim.api

local M = {}

vim.lsp.set_log_level("debug")
-- Credit https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
function M.on_attach(client, bufnr)
	if client.resolved_capabilities.document_formatting then
		vim.cmd([[augroup lsp_formatting]])
		vim.cmd([[autocmd!]])
		vim.cmd([[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]])
		vim.cmd([[augroup END]])
	end

	local opts = { noremap = true, silent = true }

	local function buf_set_keymap(mode, mapping, command)
		api.nvim_buf_set_keymap(bufnr, mode, mapping, command, opts)
	end

	api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	buf_set_keymap("n", "<leader>d", "<cmd> lua vim.lsp.buf.definition()<CR>")
	buf_set_keymap("n", "<leader>t", "<cmd> lua vim.lsp.buf.type_definition()<CR>")
	buf_set_keymap("n", "<leader>i", "<cmd> lua vim.lsp.buf.implementation()<CR>")
	-- Handled by telescope.
	-- buf_set_keymap('n', '<leader>r', '<cmd> lua vim.lsp.buf.references()<CR>')
	buf_set_keymap("n", "<leader>K", "<cmd> lua vim.lsp.buf.hover()<CR>")
	buf_set_keymap("n", "<leader>e", "<cmd> lua vim.lsp.diagnostic.goto_next()<CR>")
	buf_set_keymap("n", "<leader>E", "<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>")
	buf_set_keymap("n", "<leader>u", "<cmd> lua vim.lsp.buf.incoming_calls()<CR>")
	buf_set_keymap("n", "<leader>U", "<cmd> lua vim.lsp.buf.outgoing_calls()<CR>")
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
M.capabilities = capabilities

return M
