local lsp = require("languages.lsp")

local M = {}

M.efm = {
	{
		formatCommand = "stylua - --config-path ~/.config/stylua/stylua.toml",
		formatStdin = true,
	},
}

M.all_format = { efm = "Stylua" }

M.default_format = "efm"
local cache = "/Users/awalker/.cache/"
local sumneko_root_path = cache .. "nvim/lspconfig/sumneko_lua/lua-language-server"
local sumneko_binary = cache .. "nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

M.lsp = {
	capabilities = lsp.capabilities,
	on_attach = lsp.on_attach,
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
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
