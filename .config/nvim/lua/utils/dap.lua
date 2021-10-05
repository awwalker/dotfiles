local M = {}

local ensure_script = os.getenv("PLAID_PATH") .. "/go.git/scripts/ensure_debugger_session.sh"
local batch_mocha_script = os.getenv("HOME") .. "/.start_mocha_batch.sh"

function M.get_debugging_port(service_name)
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

function M.start_devenv_debug_session()
	local service_name = vim.fn.input("\nDebugee Service: ")
	local port = M.get_debugging_port(service_name) or vim.fn.input("\nDebuggee Port: ")
	-- Start the debugger in the devenv service.
	vim.fn.system({ ensure_script, service_name })
	io.write(string.format("Debug session for %s with port %d", service_name, port))
	return service_name, port
end

function M.get_devenv_host()
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

return M
