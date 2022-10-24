local handlers = require("lsp.handlers")

local M = {}

M.efm = {
	--	{
	--		formatCommand = "prettier --tab-width=2 --use-tabs=false --stdin-filepath ${INPUT}",
	--		formatStdin = true,
	--	},
	{
		lintCommand = "yamllint -f parsable -",
		lintStdin = true,
	},
}

M.all_format = { efm = "Prettier" }

M.default_format = "efm"

M.lsp = {
	capabilities = handlers.capabilities,
	on_attach = handlers.on_attach,
}

return M
