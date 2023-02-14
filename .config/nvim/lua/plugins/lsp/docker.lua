local M = {}
local lsp = require("plugins.lsp2.lsp")

M.nls = {
  filetypes = { "dockerfile" },
  command = "hadolint",
  args = { "--no-color", "--no-fail", "--format=json", "-" },
}

M.lsp = {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities(),
}

return M
