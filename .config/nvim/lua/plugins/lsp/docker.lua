local M = {}

M.nls = {
	filetypes = { "dockerfile" },
	command = "hadolint",
	args = { "--no-color", "--no-fail", "--format=json", "-" },
}

M.lsp = {}

return M
