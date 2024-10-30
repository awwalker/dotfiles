local M = {}
local config = {
	-- disable virtual text
	virtual_text = false,
	-- show signs
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
		severity = {
			min = vim.diagnostic.severity.INFO,
		},
		severity_sort = true,
		priority = 10,
	},
	-- Enable lsp cursor word highlighting
	document_highlight = {
		enabled = true,
	},
	-- add an
	-- underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		wrap_at = 35,
		severity_sort = true,
	},
	jump = {
		float = true,
		wrap = true,
		severity = {
			min = vim.diagnostic.severity.INFO,
		},
	},
}

vim.diagnostic.config(config)
return M
