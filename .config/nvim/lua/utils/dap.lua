local M = {}

function M.get_plaid_path()
  local plaid_path = os.getenv("PLAID_PATH")
  if plaid_path ~= nil then
    return plaid_path
  end
  return ''
end

local ensure_script = M.get_plaid_path() .. "/go.git/scripts/ensure_debugger_session.sh"
local batch_mocha_script = os.getenv("HOME") .. "/.start_mocha_batch.sh"

function M.get_debugging_port(service_name)
	if service_name == "stasher" then
		service_name = "scheduler_stasher"
	end
	local ports_compose = io.open(M.get_plaid_path() .. "/go.git/proto/src/plaidtypes/coretypes/service.proto", "r")
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
		host = "10.132.2.22"
	elseif remoteness == "local" then
		host = "127.0.0.1"
	else
		io.write(string.format("Unusable remoteness value: %s", remoteness))
	end
	return host
end

return M
