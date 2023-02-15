local M = {}

M.nls = {
  extra_args = { "--config-path", vim.fn.expand("~/.config/stylua/stylua.toml"),
                 "--search-parent-directories" },
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
