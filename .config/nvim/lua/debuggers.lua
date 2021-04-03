local M = {}
local goLaunchConfig
local goLaunchAdapter
local pythonAttachConfig
local pythonAttachAdapter

local dap = require("dap")

local function get_debugging_port()
  io.write('Input service name to debug: ');
  local app_name = io.read()
  local ports_compose = io.open(os.getenv("PLAID_PATH") .. "/go.git/proto/src/plaidtypes/coretypes/service.proto", "r")
  for line in ports_compose:lines() do
      -- Match lines like: "    SERVICE_FEATURE_SERVER_CONSUMER = 181 [" and pull the 181.
      local proto_base = string.match(line, "^%s-SERVICE_" .. string.upper(app_name) .. "%s-=%s-(%d+)%s-%[")
      if proto_base ~= nil then
          return 50000 + (proto_base + 1) * 10 - 1
      end
  end
  ports_compose:close()
  io.write("Unable to dynamically find port for: ", app_name);
  io.write("Please input port now or `q` to quit");
  local input = io.read();
  if input == "q" or string.match(input, "%d+") == nil then
      return nil
  end
  return nil
end

-- Python
dap.adapters.python = {
  type = 'executable';
  command = os.getenv('HOME') .. '/.pyenv/versions/neovim3/bin/python';
  args = { '-m', 'debugpy.adapter' };
}

dap.adapters.local_devenv_python = {
  type = 'server';
  host = '127.0.0.1';
  port = '';-- get_debugging_port();
}

dap.adapters.remote_devenv_python = {
  type = 'server';
  host = '10.100.10.44';
  port = '';-- get_debugging_port();
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = 'Launch file';
    program = "${file}";
    console = 'integratedTerminal';
    pythonPath = function()
      local cwd = vim.fn.getcwd();
      return os.getenv("HOME") .. '/.pyenv/versions/covid/bin/python';
    end
  },
  {
    type = "remote-python";
    request = "attach";
    connect = {
        host = host;
        port = '';-- tonumber(get_debugging_port());
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
  },
}

-- Go
dap.adapters.go = {
  type = "executable";
  command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node";
  args = { os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js" };
}

dap.configurations.go = {
  {
     type = "go";
     request = "attach";
     mode = "remote";
     name = "Remote Attached Debugger";
     dlvToolPath = os.getenv('HOME') .. "/go/bin/dlv";
     remotePath = "/opt/gopath/src/github.plaid.com/plaid/go.git";
     port = '';-- tonumber(get_debugging_port());
     cwd = vim.fn.getcwd();
  },
}

-- Node / Typescript
dap.adapters.node2 = {
  type = "executable";
  name = "node2";
  command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node";
  args = { os.getenv("HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" };
}

dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = "node2";
    name = "pdaas";
    request = "launch";
    program = "/Users/awalker/plaid/pdaas/build/pd2/scripts/cli/index.js";
    runtimeExecutable = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node";
    cwd = vim.fn.getcwd();
    sourceMaps = true;
    protocol = "inspector";
    console = "integratedTerminal";
    sourceMapPathOverrides = {
        ["${workspaceFolder}/src/pd2/extractor/**/*.ts"] = "${workspaceFolder}/build/pd2/extractor/**/*.js"
    };
    outFiles = { "${workspaceFolder}/build/**/*.js", "!**/node_modules/**" };
  },
}

local function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
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
      goLaunchConfig = {
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
      goLaunchAdapter = {
          type = "executable";
          command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node";
          args = {os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js"};
      }
  end
  if not goLaunchConfig or not goLaunchAdapter then
      io.write("Config or Adapter not setup! Use :DebugGo <app name>");
      return
  end
  io.write("Connecting to: ", serviceName, ":", goLaunchConfig.port)
  vim.fn.system({"/Users/awalker/plaid/go.git/scripts/ensure_debugger_session.sh", serviceName})
  local session = dap.launch(goLaunchAdapter, goLaunchConfig, {})
  if session == nil then
      io.write("Error launching adapter");
  end
  dap.repl.open({}, 'vsplit')
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
      io.write("Error connecting to adapter");
  end
  dap.repl.open({}, 'vsplit')
end

return M
