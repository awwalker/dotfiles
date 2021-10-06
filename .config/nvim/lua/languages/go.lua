local lsp = require("languages.lsp")

local M = {}

M.efm = {
	{
		formatCommand = "goimports",
		formatStdin = true,
	},
	{
		formatCommand = "gofumpt",
		formatStdin = true,
	},
  -- Provides too many false positive U1000.
	-- {
	-- 	lintCommand = "staticcheck ${INPUT}",
	-- 	lintFormats = {
	-- 		"%f:%l:%c: %m",
	-- 	},
	-- },
	{
		lintCommand = "golint",
		lintIgnoreExitCode = true,
		lintFormats = { "%f:%l:%c: %m" },
		lintSource = "golint",
	},
}

M.all_format = { efm = "Goimports gofumpt" }

M.default_format = "efm"

M.lsp = {
	capabilities = lsp.capabilities,
	cmd = { "gopls", "serve" },
	flags = {
		debounce_text_changes = 300,
	},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
		},
		staticcheck = true,
	},
	on_attach = lsp.on_attach,
}

return M
