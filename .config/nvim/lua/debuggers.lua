-- =============================
--              DAP
-- =============================
local dap = require('dap')
dap.set_log_level('TRACE');

-- Enable virtual text.
vim.g.dap_virtual_text = true

local ensure_script = os.getenv('PLAID_PATH') .. '/go.git/scripts/ensure_debugger_session.sh';

local function get_debugging_port(service_name)
  local ports_compose = io.open(
    os.getenv('PLAID_PATH') .. '/go.git/proto/src/plaidtypes/coretypes/service.proto', 'r'
  )
  local port = nil
  for line in ports_compose:lines() do
    -- Match lines like: "    SERVICE_FEATURE_SERVER_CONSUMER = 181 [" and pull the 181.
    local proto_base = string.match(
      line,
      '^%s-SERVICE_' .. string.upper(service_name) .. '%s-=%s-(%d+)%s-%['
    )
    if proto_base ~= nil then
      port = 50000 + (proto_base + 1) * 10 - 1
      break
    end
  end
  ports_compose:close()
  return port
end

local function start_devenv_debug_session()
  local service_name = vim.fn.input('Debugee Service: ')
  local port = get_debugging_port(service_name) or vim.fn.input('Debuggee Port: ')
  -- Start the debugger in the devenv service.
  vim.fn.system({ensure_script, service_name})
  io.write(string.format('Debug session for %s with port %d', service_name, port))
  return service_name, port;
end

-- =============================
--            ADAPTERS
-- =============================

-- PYTHON
dap.adapters.python = {
  type = 'executable';
  command = os.getenv('HOME') .. '/.pyenv/versions/neovim3/bin/python';
  args = { '-m', 'debugpy.adapter' };
}

dap.adapters.devenv_python = function(cb, config)
  local _, port = start_devenv_debug_session();
  local remoteness = vim.fn.input('Remote or Local Devenv: ')
  local host;
  if remoteness == 'remote' then
    host = '10.131.1.149';
  elseif remoteness == 'local' then
    host = '127.0.0.1';
  else
    io.write(string.format('Unusable remoteness value: %s', remoteness));
  end
  cb({
    type = 'server';
    host = host;
    port = port;
    enrich_config = function(config, on_config)
      local f_config = vim.deepcopy(config)
      if f_config.connect ~= nil then
        f_config.connect.port = port;
        f_config.connect.host = host;
      end
      on_config(f_config)
    end;
  })
end

-- GO
dap.adapters.go = function(cb, config)
  local cb_input = {
    type = 'executable';
    command = os.getenv('HOME') .. '/.nvm/versions/node/v12.18.2/bin/node';
    args = { os.getenv('HOME') .. '/vscode-go/dist/debugAdapter.js' };
  };
  if config.request == 'attach' and config.mode == 'remote' then
    local _, port = start_devenv_debug_session()
    cb_input.enrich_config = function(config, on_config)
      local f_config = vim.deepcopy(config)
      f_config.port = tonumber(port)
      on_config(f_config)
    end;
  elseif config.mode == 'test' then
    local package = vim.fn.input('Go package to debug: ');
    cb_input.enrich_config = function(config, on_config)
      local f_config = vim.deepcopy(config)
      f_config.program = os.getenv('PLAID_PATH') .. '/go.git/' .. package
      on_config(f_config)
    end;
  end
  cb(cb_input)
end;

-- NODE / TYPESCRIPT
dap.adapters.node2 = {
  type = 'executable';
  command = os.getenv('HOME') .. '/.nvm/versions/node/v12.18.2/bin/node';
  args = { os.getenv('HOME') .. '/vscode-node-debug2/out/src/nodeDebug.js' };
}

-- =============================
--         CONFIGURATIONS
-- =============================
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = 'Launch File';
    program = '${file}';
    console = 'integratedTerminal';
    pythonPath = function()
      return os.getenv('HOME') .. '/.pyenv/versions/neovim3/bin/python';
    end;
  },
  {
    type = 'devenv-python';
    request = 'attach';
    mode = 'remote';
    connect = {};
    name = 'Devenv Debugger';
    cwd = vim.fn.getcwd();
    pathMappings = {
      {
        localRoot = vim.fn.getcwd();
        remoteRoot = '/usr/src/app';
      };
    };
  },
}

dap.configurations.go = {
  {
    type = 'go';
    request = 'attach';
    mode = 'remote';
    name = 'Remote Attached Debugger';
    remotePath = '/opt/gopath/src/github.plaid.com/plaid/go.git';
    cwd = vim.fn.getcwd();
    dlvToolPath = vim.fn.exepath('dlv');
  },
  {
    type = 'go';
    name = 'Local File Debugger';
    request = 'launch';
    program = '${file}';
    dlvToolPath = vim.fn.exepath('dlv');
  },
  {
    type = 'go';
    request = 'launch';
    mode = 'test';
    name = 'Local Test Debugger';
    envFile = os.getenv('PLAID_PATH') .. '/go.git/environment/experimental';
    dlvToolPath = vim.fn.exepath('dlv');
  }
}

dap.configurations.javascript = {
  {
    type = 'node2';
    request = 'launch';
    program = '${file}';
    cwd = vim.fn.getcwd();
    sourceMaps = true;
    protocol = 'inspector';
    console = 'integratedTerminal';
  },
  {
    type = 'node2';
    request = 'launch';
    name = 'pdaas';
    program = os.getenv('PLAID_PATH') .. '/pdaas/build/pd2/scripts/cli/index.js';
    runtimeExecutable = os.getenv('HOME') .. '/.nvm/versions/node/v12.18.2/bin/node';
    cwd = vim.fn.getcwd();
    sourceMaps = true;
    protocol = 'inspector';
    console = 'integratedTerminal';
    sourceMapPathOverrides = {
      ['${workspaceFolder}/src/pd2/extractor/**/*.ts'] = '${workspaceFolder}/build/pd2/extractor/**/*.js'
    };
    outFiles = { '${workspaceFolder}/build/**/*.js', '!**/node_modules/**' };
  },
}


