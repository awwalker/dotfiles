local lsp = require("languages.lsp")

local M = {}

M.efm = {
	{
		lintCommand = "markdownlint -s",
		lintSource = "markdownlint",
		lintStdin = true,
	},
	{
		formatCommand = "pandoc -f gfm -t gfm -sp --tab-stop=2",
		formatStdin = true,
	},
}

M.lsp = {
	capabilities = lsp.capabilities,
	on_attach = function(client)
		-- Handled by EFM.
		client.resolved_capabilities.document_formatting = false

		lsp.on_attach(client, 0)
	end,
	cmd = { "zeta-note" },
}

return M
