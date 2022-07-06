local lsp = require("languages.lsp")

local M = {}

M.efm = {
	{
		lintCommand = "markdownlint -s",
		lintSource = "markdownlint",
		lintStdin = true,
	},
	{
		formatCommand = "pandoc -t gfm -sp --tab-stop=2",
		formatStdin = true,
	},
}

M.lsp = {
	capabilities = lsp.capabilities,
	on_attach = function(client)
		-- Handled by EFM.
		client.server_capabilities.document_formatting = false

		lsp.on_attach(client, 0)
	end,
	cmd = { "marksman" },
}

return M
