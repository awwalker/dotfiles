local M = {}

M.lsp = {
  cmd = { "gopls", "serve" },
  flags = {
    debounce_text_changes = 300,
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
    },
    staticcheck = true,
  },
}

return M
