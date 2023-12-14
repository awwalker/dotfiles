local M = {}

M.nls = {
	extra_args = {
		"--config-path",
		vim.fn.expand("~/.config/stylua/stylua.toml"),
		"--search-parent-directories",
	},
}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

M.lsp = {
	Lua = {
		runtime = {
			version = "LuaJIT",
			path = runtime_path,
		},
		format = {
			enable = false,
		},
		workspace = {
			checkThirdParty = false,
			library = {
				vim.env.VIMRUNTIME,
			},
		},
		telemetry = {
			enable = false,
		},
	},
}
return M
