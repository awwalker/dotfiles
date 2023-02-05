local handlers = require("lsp.handlers")

local M = {}

M.efm = {}

M.lsp = {
  capabilities = handlers.capabilities,
  on_attach = function(client)
    client.server_capabilities.document_formatting = {
      tabSize = 2,
    }
    handlers.on_attach(client, 0)
  end,
}

return M
