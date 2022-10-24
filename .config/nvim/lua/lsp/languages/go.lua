local handlers = require("lsp.handlers")

local M = {}

M.efm = {
	{
		formatCommand = "goimports",
		formatStdin = true,
	},
	-- {
	-- 	formatCommand = "gofumpt",
	-- 	formatStdin = true,
	-- },
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
		lintStdin = true,
	},
}

M.all_format = { efm = "goimports" }

M.default_format = "efm"

M.lsp = {
	capabilities = handlers.capabilities,
	-- Default command.
	cmd = { "gopls", "serve" },
	-- cmd = { "gopls", "-remote=auto", "-logfile=auto", "-debug=:0", "-remote.debug=:0", "-rpc.trace" },
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
	on_attach = function(client)
		client.server_capabilities.document_formatting = false

		handlers.on_attach(client, 0)
	end,
}

return M
