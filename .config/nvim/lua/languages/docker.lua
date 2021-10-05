local lsp = require('languages.lsp')
local M = {}

M.efm = {
    {
        lintCommand = 'hadolint --no-color ${INPUT}',
        lintStdin = false,
        lintFormats = {
            '%f:%l %m',
        },
    }
}

M.all_format = { dockerls = 'DockerLS' }

M.default_format = 'dockerls'

M.lsp = {
    capabilities = lsp.capabilities,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        lsp.post_attach(client)
    end,
}

return M
