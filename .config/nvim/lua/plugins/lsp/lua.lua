local M = {}

M.nls = {
  condition = function(utils)
    utils.root_has_file({ "stylua.toml", ".stylua.toml" })
  end,
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
    diagnostics = {
      globals = { "vim" },
    },
    format = {
      enable = false,
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
}
return M
