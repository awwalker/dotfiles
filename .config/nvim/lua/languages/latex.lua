local lsp = require('languages.lsp')

local M = {}

M.efm = {
  {
    formatCommand = 'pandoc -f latex -t latex -sp --tab-stop=2',
    formatStdin = true,
  }
}

M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = function(client)
    -- Handled by EFM.
    client.resolved_capabilities.document_formatting = false
    lsp.on_attach(client, 0)
  end,
  cmd = { "texlab" },
}

return M
