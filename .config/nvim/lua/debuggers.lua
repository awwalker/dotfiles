local M = {}
local goAttachConfig
local goAttachAdapter
local pythonAttachConfig
local pythonAttachAdapter

local function wait(seconds)
    local start = os.time()
    repeat until os.time() > start + seconds
end

local function get_debugging_port(appName)
    local ports_compose = io.open(os.getenv("PLAID_PATH") .. "/go.git/proto/src/plaidtypes/coretypes/service.proto", "r")
    for line in ports_compose:lines() do
        -- Match lines like: "    SERVICE_FEATURE_SERVER_CONSUMER = 181 [" and pull the 181.
        local proto_base = string.match(line, "^%s-SERVICE_" .. string.upper(appName) .. "%s-=%s-(%d+)%s-%[")
        if proto_base ~= nil then
            return 50000 + (proto_base + 1) * 10 - 1
        end
    end
    ports_compose:close()
    io.write("Unable to dynamically find port for: ", appName);
    io.write("Please input port now or `q` to quit");
    local input = io.read();
    if input == "q" or string.match(input, "%d+") == nil then
        return nil
    end
end

M.attach_go_debugger = function(args)
    local dap = require "dap"
    local serviceName = args[1]
    local raw_port = get_debugging_port(serviceName)
    if raw_port == nil then
        io.write("Unable to get port; quitting");
        return
    end

    if args and #args > 0 then
        goAttachConfig = {
            type = "go";
            request = "attach";
            mode = "remote";
            name = "Remote Attached Debugger";
            dlvToolPath = os.getenv('HOME') .. "/go/bin/dlv";
            remotePath = "/opt/gopath/src/github.plaid.com/plaid/go.git";
            port = tonumber(raw_port);
            cwd = vim.fn.getcwd();
        }
        -- The adapter has not been started yet.
        -- Spin it up.
        goAttachAdapter = {
            type = "executable";
            command = "node";
            args = {os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js"};
        }
    end
    if not goAttachConfig or not goAttachAdapter then
        io.write("Config or Adapter not setup! Use :DebugGo <app name>");
        return
    end
    io.write("Connecting to: ", serviceName, ":", goAttachConfig.port)
    vim.fn.system({"/Users/awalker/plaid/go.git/scripts/ensure_debugger_session.sh", serviceName})
    local session = dap.launch(goAttachAdapter, goAttachConfig)
    if session == nil then
        io.write("Error launching adapter");
    end
    dap.repl.open()
end

M.attach_python_debugger = function(args)
    local dap = require "dap"
    local serviceName = args[1]
    local host = "127.0.0.1"
    if args and #args > 1 then
        host = "10.100.10.44"
    end
    -- Spawn the debugpy server and adapter in the container.
    local co = coroutine.create(function()
        vim.fn.system({"/Users/awalker/plaid/go.git/scripts/ensure_debugger_session.sh", serviceName})
    end)
    print(coroutine.resume(co))
    local raw_port = get_debugging_port(serviceName)
    if raw_port == nil then
        io.write("Unable to get port; quitting");
        return
    end

    if args and #args > 0 then
        pythonAttachConfig = {
            type = "python";
            request = "attach";
            connect = {
                host = host;
                port = tonumber(raw_port);
            };
            mode = "remote";
            name = "Remote Attached Debugger";
            cwd = vim.fn.getcwd();
            pathMappings = {
                {
                    localRoot = vim.fn.getcwd();
                    remoteRoot = "/usr/src/app";
                };
            };
        }
        -- The adapter has been started.
        -- Connect to it.
        pythonAttachAdapter = {
            type = "server";
            host = host;
            port = tonumber(raw_port);
        }
    end
    if not pythonAttachConfig or not pythonAttachAdapter then
        io.write("Config or Adapter not setup! Use :DebugPy <app name>");
        return
    end
    while coroutine.status(co) ~= "dead" do
        print("waiting")
        wait(2)
    end
    io.write("Connecting to: ", serviceName, ":", tonumber(raw_port))
    local session = dap.attach(host, tonumber(raw_port), pythonAttachConfig)
    if session == nil then
        io.write("Error launching adapter");
    end
    dap.repl.open()
end

return M
