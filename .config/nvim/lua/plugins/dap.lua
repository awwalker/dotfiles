-- =============================
--              DAP
-- =============================
local dap = require("dap")
local utils = require("utils")
dap.set_log_level("TRACE") -- logs live at ~/.cache/nvim/dap.log

-- Enable virtual text.
vim.g.dap_virtual_text = true
-- Fancy breakpoint symbol.
vim.fn.sign_define("DapBreakpoint", { text = "⭕", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "🟡", texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "🔴", texthl = "DapStopped", linehl = "debugPC", numhl = "" })

-- Auto completion in REPL.
vim.cmd([[  au FileType dap-repl lua require('dap.ext.autocompl').attach() ]])

local ensure_script = os.getenv("PLAID_PATH") .. "/go.git/scripts/ensure_debugger_session.sh"
local batch_mocha_script = os.getenv("HOME") .. "/.start_mocha_batch.sh"

local function get_debugging_port(service_name)
	if service_name == "stasher" then
		service_name = "scheduler_stasher"
	end
	local ports_compose = io.open(os.getenv("PLAID_PATH") .. "/go.git/proto/src/plaidtypes/coretypes/service.proto", "r")
	local port = nil
	for line in ports_compose:lines() do
		-- Match lines like: "    SERVICE_FEATURE_SERVER_CONSUMER = 181 [" and pull the 181.
		local proto_base = string.match(line, "^%s-SERVICE_" .. string.upper(service_name) .. "%s-=%s-(%d+)%s-%[")
		if proto_base ~= nil then
			port = 50000 + (proto_base + 1) * 10 - 1
			break
		end
	end
	ports_compose:close()
	return port
end

local function start_devenv_debug_session()
	local service_name = vim.fn.input("\nDebugee Service: ")
	local port = get_debugging_port(service_name) or vim.fn.input("\nDebuggee Port: ")
	-- Start the debugger in the devenv service.
	vim.fn.system({ ensure_script, service_name })
	io.write(string.format("Debug session for %s with port %d", service_name, port))
	return service_name, port
end

local function get_devenv_host()
	local remoteness = vim.fn.input("\nRemote or Local Devenv: ")
	local host
	if remoteness == "remote" then
		host = "10.131.1.149"
	elseif remoteness == "local" then
		host = "127.0.0.1"
	else
		io.write(string.format("Unusable remoteness value: %s", remoteness))
	end
	return host
end

-- =============================
--            ADAPTERS
-- =============================

-- PYTHON
dap.adapters.python = {
	type = "executable",
	command = os.getenv("HOME") .. "/.pyenv/versions/neovim3/bin/python",
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.devenv_python = function(cb, config)
	local _, port = start_devenv_debug_session()
	local host = get_devenv_host()
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

-- GO
dap.adapters.go = function(cb, config)
	local cb_input = {
		type = "executable",
		command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
		args = { os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js" },
	}
	if config.request == "attach" and config.mode == "remote" then
		local _, port = start_devenv_debug_session()
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

dap.adapters.dlv_spawn = function(cb, config)
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
		cb({ type = "server", host = "127.0.0.1", port = port })
	end, 100)
end

-- NODE / TYPESCRIPT
dap.adapters.node2 = function(cb, config)
	local cb_input = {
		type = "executable",
		command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
		args = { os.getenv("HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" },
	}
	if config.request == "attach" and config.mode == "remote" then
		local _, port = start_devenv_debug_session()
		cb_input.enrich_config = function(config, on_config)
			local f_config = vim.deepcopy(config)
			f_config.port = tonumber(port)
			on_config(f_config)
		end
	elseif config.mode == "test" then
		if config.request == "attach" then
			local _, port = start_devenv_debug_session()
			local host = get_devenv_host()
			vim.fn.input("\n[Optional] test filter: ")
			vim.fn.system({ batch_mocha_script })
			cb_input.enrich_config = function(config, on_config)
				local f_config = vim.deepcopy(config)
				f_config.port = tonumber(port)
				f_config.host = host
				on_config(f_config)
			end
		elseif config.request == "launch" then
			cb_input.enrich_config = function(config, on_config)
				local f_config = vim.deepcopy(config)
				local grepFilter = vim.fn.input("\n[Optional] test filter: ")
				if grepFilter ~= "" then
					table.insert(f_config.args, 1, string.format("--grep=%s", grepFilter))
				end
				print(utils.debug_print(f_config))
				on_config(f_config)
			end
		end
	end

	cb(cb_input)
end

-- =============================
--         CONFIGURATIONS
-- =============================
dap.configurations.python = {
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

dap.configurations.go = {
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

dap.configurations.typescript = {
	{
		type = "node2",
		request = "launch",
		name = "Launch File",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		restart = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
	{
		type = "node2",
		request = "launch",
		name = "PDaaS Launch",
		program = os.getenv("PLAID_PATH") .. "/pdaas/build/pd2/scripts/cli/index.js",
		runtimeExecutable = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
		sourceMapPathOverrides = {
			["${workspaceFolder}/src/pd2/extractor/**/*.ts"] = "${workspaceFolder}/build/pd2/extractor/**/*.js",
		},
		outFiles = { "${workspaceFolder}/build/**/*.js", "!**/node_modules/**" },
		restart = true,
	},
	-- Works for unit tests that do not need /development-certs/.
	{
		type = "node2",
		request = "launch",
		mode = "test",
		name = "PDaaS Test",
		program = "${workspaceFolder}/node_modules/.bin/mocha",
		console = "integratedTerminal",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		restart = true,
		skipFiles = {
			"<node_internals>/**",
			"**/node_modules/**",
		},
		runtimeExecutable = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
		args = {
			-- Problematic.
			-- "--max-http-header-size=131072",
			-- Good.
			"--exit",
			"--require=source-map-support/register",
			"--require=${workspaceFolder}/build/test/init",
			"--file=${workspaceFolder}/build/test/global-hooks",
			"--timeout=999999",
			"--colors",
		},
		envFile = "${workspaceFolder}/environment/development",
		env = {
			["NODE_EXTRA_CA_CERTS"] = "${workspaceFolder}/resources/pd2/cert/extended-intermediate-certificates.pem",
		},
		protocol = "inspector",
		outFiles = { "${workspaceFolder}/build/**/*.js", "!**/node_modules/**" },
	},
	{
		type = "node2",
		request = "attach",
		mode = "remote",
		name = "Remote Attach",
		cwd = vim.fn.getcwd(),
		localRoot = vim.fn.getcwd(),
		remoteRoot = "/usr/src/app",
		sourceMaps = true,
		skipFiles = {
			"**/node_modules/**",
			"<node_internals>/**",
		},
		protocol = "inspector",
		console = "integratedTerminal",
		outFiles = { "${workspaceFolder}/build/**/*.js", "!**/node_modules/**" },
		restart = true,
	},
	-- Doesn't work because needs /development-certs/ even for local unit tests.
	-- {
	--   type = 'node2';
	--   request = 'launch';
	--   mode = 'test';
	--   name = 'Batch Test';
	--   program = '${workspaceFolder}/node_modules/.bin/mocha';
	--   console = 'integratedTerminal';
	--   cwd = vim.fn.getcwd();
	--   sourceMaps = true;
	--   restart = true;
	--   skipFiles = {
	--     '<node_internals>/**',
	--     '**/node_modules/**',
	--   };
	--   runtimeExecutable = os.getenv('HOME') .. '/.nvm/versions/node/v12.18.2/bin/node';
	--   args = {
	--     "--exit",
	--     "--require=source-map-support/register",
	--     "--require=${workspaceFolder}/build/test/testutils/init",
	--     "--colors",
	--     "${workspaceFolder}/build/test/**unit/**/*.js",
	--   };
	--   envFile = "${workspaceFolder}/environment/development";
	--   protocol = 'inspector';
	--   outFiles = { '${workspaceFolder}/build/**/*.js', '!**/node_modules/**' };
	-- },
}
