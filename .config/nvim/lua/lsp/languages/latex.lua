local handlers = require("lsp.handlers")

local M = {}

M.efm = {
	{
		formatCommand = "pandoc -f latex -t latex -sp --tab-stop=2",
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
	cmd = { "texlab" },
}

return M
