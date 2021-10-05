local lsp = require('languages.lsp')
local M = {}

M.efm = {
    {
        formatCommand = 'prettier --tab-width=4 --use-tabs=false --stdin-filepath ${INPUT}',
        formatStdin = true,
    },
}

M.all_format = { efm = 'Prettier' }

M.default_format = 'efm'

M.lsp = {
    cmd = { "json-languageserver", "--stdio" },
    capabilities = lsp.capabilities,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        lsp.post_attach(client)
    end,
}

return M
