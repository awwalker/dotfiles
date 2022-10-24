local handlers = require("lsp.handlers")

local M = {}

M.efm = {
	{
		lintCommand = "markdownlint -c /Users/aaronwalker/.config/markdownlint/markdownlint.json -s",
		lintSource = "markdownlint",
		lintStdin = true,
	},
	{
		formatCommand = "pandoc -t gfm -sp --tab-stop=2",
		formatStdin = true,
	},
}

M.lsp = {
	capabilities = handlers.capabilities,
	on_attach = function(client)
		-- Handled by EFM.
		client.server_capabilities.document_formatting = false

		handlers.on_attach(client, 0)
	end,
	cmd = { "marksman" },
}

return M
