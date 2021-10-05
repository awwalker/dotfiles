-- =============================
--      Python Debugging
-- =============================
local M = {}

local dap_utils = require("utils.dap")

-- =============================
--            ADAPTERS
-- =============================
M.adapters = {}

M.adapters.python = {
	type = "executable",
	command = os.getenv("HOME") .. "/.pyenv/versions/neovim3/bin/python",
	args = { "-m", "debugpy.adapter" },
}

M.adapters.devenv_python = function(cb, config)
	local _, port = dap_utils.start_devenv_debug_session()
	local host = dap_utils.get_devenv_host()
	cb({
		type = "server",
		host = host,
		port = port,
		enrich_config = function(config, on_config)
			local f_config = vim.deepcopy(config)
			if f_config.connect ~= nil then
				f_config.connect.port = port
				f_config.connect.host = host
			end
			on_config(f_config)
		end,
	})
end

-- =============================
--        CONFIGURATIONS
-- =============================

M.configurations = {
	{
		type = "python",
		request = "launch",
		name = "Launch File",
		program = "${file}",
		console = "integratedTerminal",
		pythonPath = function()
			return os.getenv("HOME") .. "/.pyenv/versions/neovim3/bin/python"
		end,
	},
	{
		type = "devenv-python",
		request = "attach",
		mode = "remote",
		connect = {},
		name = "Devenv Debugger",
		cwd = vim.fn.getcwd(),
		pathMappings = {
			{
				localRoot = vim.fn.getcwd(),
				remoteRoot = "/usr/src/app",
			},
		},
	},
}

return M
