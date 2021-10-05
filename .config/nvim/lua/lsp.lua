local lsp = require('languages.lsp')

require('lspconfig').efm.setup({
    root_dir = vim.loop.cwd,
    filetypes = {
        'typescript',
        'python',
        'go',
        'lua',
        'yaml',
        'json',
        'dockerfile',
    },

    init_options = { documentFormatting = true, codeAction = true },
    settings = {
        rootMarkers = { '.git/', '.config/' },
        languages = {
            ["="] = require('languages.misspell').efm,
            typescript = require('languages.typescript').efm,
            python = require('languages.python').efm,
            go = require('languages.go').efm,
            lua = require('languages.lua').efm,
            yaml = require('languages.yaml').efm,
            json = require('languages.json').efm,
            dockerfile = require('languages.docker').efm,
        },
    },

    on_attach = function(client)
      lsp.post_attach(client)
    end,
    capabilities = lsp.capabilities,
})
