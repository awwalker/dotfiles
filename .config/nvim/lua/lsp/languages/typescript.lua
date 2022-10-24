local handlers = require("lsp.handlers")

local M = {}

M.efm = {
	{
		formatCommand = "prettier --tab-width=2 --use-tabs=false --stdin-filepath ${INPUT}",
		formatStdin = true,
  },
  {
		lintCommand = "eslint -f visualstudio --stdin --stdin-filename ${INPUT}",
		-- lintIgnoreExitCode = true,
		lintStdin = true,
		lintFormats = {
			"%f(%l,%c): %tarning %m",
			"%f(%l,%c): %rror %m",
		},
	},
}

M.all_format = {
	efm = "Prettier",
	tsserver = "Tssever",
}

M.default_format = "efm"

M.lsp = {
	capabilities = handlers.capabilities,
	on_attach = function(client)
		client.server_capabilities.document_formatting = false

		handlers.on_attach(client, 0)
	end,
}

return M
