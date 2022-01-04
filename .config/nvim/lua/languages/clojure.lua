local lsp = require("languages.lsp")

local M = {}

M.efm = {}


M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
		lsp.on_attach(client, 0)
  end,
}

return M
