-- =============================
--        GO Debugging
-- =============================
local M = {}

local debug_utils = require("utils.dap")
local utils = require("utils.core")

-- =============================
--            ADAPTERS
-- =============================
M.adapters = {}

M.adapters.go = function(cb, config)
	local cb_input = {
		type = "executable",
		command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
		args = { os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js" },
	}
	if config.request == "attach" and config.mode == "remote" then
		local _, port = debug_utils.start_devenv_debug_session()
		cb_input.enrich_config = function(config, on_config)
			local f_config = vim.deepcopy(config)
			f_config.port = tonumber(port)
			on_config(f_config)
		end
	elseif config.request == "launch" and config.mode == "test" then
		cb_input.enrich_config = function(config, on_config)
			local f_config = vim.deepcopy(config)
			if f_config.program == nil then
				local package = vim.fn.input("\nWhich go package to debug: ")
				-- TODO gate plaid addition based on path.
				f_config.program = os.getenv("PLAID_PATH") .. "/go.git/" .. package
			end
			print(utils.debug_print(f_config))
			on_config(f_config)
		end
	end
	cb(cb_input)
end

M.adapters.dlv_spawn = function(cb, config)
	local stdout = vim.loop.new_pipe(false)
	local handle
	local pid_or_err
	local port = 38697
	local opts = {
		stdio = { nil, stdout },
		args = { "dap", "-l", "127.0.0.1:" .. port },
		detached = true,
	}
	handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
		stdout:close()
		handle:close()
		if code ~= 0 then
			print("dlv exited with code", code)
		end
	end)
	assert(handle, "Error running dlv: " .. tostring(pid_or_err))
	stdout:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			vim.schedule(function()
				--- You could adapt this and send `chunk` to somewhere else
				require("dap.repl").append(chunk)
			end)
		end
	end)
	-- Wait for delve to start
	vim.defer_fn(function()
		local cb_input = {
			type = "server",
			host = "127.0.0.1",
			port = port,
		}
		if config.request == "launch" and config.mode == "test" then
			cb_input.enrich_config = function(config, on_config)
				local f_config = vim.deepcopy(config)
				if f_config.program == nil then
					local package = vim.fn.input("\nWhich go package to debug: ")
					f_config.program = os.getenv("PLAID_PATH") .. "/go.git/" .. package
				end
				on_config(f_config)
			end
			cb(cb_input)
		end
	end, 100)
end

-- =============================
--         CONFIGURATIONS
-- =============================
M.configurations = {
	{
		type = "go",
		request = "attach",
		mode = "remote",
		name = "Remote Attached Debugger",
		remotePath = "/opt/gopath/src/github.plaid.com/plaid/go.git",
		cwd = vim.fn.getcwd(),
		dlvToolPath = vim.fn.exepath("dlv"),
	},
	{
		type = "dlv_spawn",
		name = "Local File Debugger",
		request = "launch",
		program = "${file}",
		dlvToolPath = vim.fn.exepath("dlv"),
	},
	{
		type = "dlv_spawn",
		request = "launch",
		mode = "test",
		name = "Local Test Debugger",
		envFile = os.getenv("PLAID_PATH") .. "/go.git/environment/devenv",
		dlvToolPath = vim.fn.exepath("dlv"),
	},
}

return M
