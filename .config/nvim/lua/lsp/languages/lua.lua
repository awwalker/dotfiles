local handlers = require("lsp.handlers")

local M = {}

M.efm = {
	{
		formatCommand = "stylua - --config-path ~/.config/stylua/stylua.toml",
		formatStdin = true,
	},
}

M.all_format = { efm = "Stylua" }

M.default_format = "efm"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

M.lsp = {
	capabilities = handlers.capabilities,
	on_attach = function(client)
		-- Handled by EFM.
		client.server_capabilities.document_formatting = false

		handlers.on_attach(client, 0)
	end,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				maxPreload = 2000,
				preloadFileSize = 150,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
return M
