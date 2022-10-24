local handlers = require('lsp.handlers')

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
    capabilities = handlers.capabilities,
    on_attach = handlers.on_attach,
}

return M
