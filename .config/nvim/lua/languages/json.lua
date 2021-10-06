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
    on_attach = lsp.on_attach,
}

return M
