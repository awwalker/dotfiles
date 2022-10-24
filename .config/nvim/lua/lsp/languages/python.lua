local handlers = require("lsp.handlers")

local M = {}

local black = {
	formatCommand = "black --line-length 100 --quiet -",
	formatStdin = true,
}
local flake8 = {
	lintCommand = "flake8 --max-line-length 100 --stdin-display-name ${INPUT} -",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	lintSource = "flake8",
}
local mypy = {
	lintCommand = "mypy --show-column-numbers --follow-imports silent",
	lintFormats = {
		"%f:%l:%c: %trror: %m",
		"%f:%l:%c: %tarning: %m",
		"%f:%l:%c: %tote: %m",
	},
	lintIgnoreExitCode = true,
	lintSource = "mypy",
}
-- Not used.
-- local isort = {
--         formatCommand = "isort --profile black -",
--         formatStdin = true,
-- }
M.efm = {
	black,
	flake8,
	mypy,
	-- isort,
}

M.all_format = { efm = "Black" }

M.default_format = "efm"

M.lsp = {
	capabilities = handlers.capabilities,
	on_attach = function(client)
		client.server_capabilities.document_formatting = false

		handlers.on_attach(client, 0)
	end,
}
return M
