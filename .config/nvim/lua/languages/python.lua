local lsp = require('languages.lsp')
local M = {}

local home = os.getenv('HOME')

local black = {
  formatCommand = 'black --line-length 100 -',
  formatStdin = true,
}
local flake8 = {
  lintCommand = 'flake8 --max-line-length 100 --stdin-display-name ${INPUT} -',
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
  lintIgnoreExitCode = true,
  lintSource = 'flake8',
}
local mypy = {
  lintCommand = 'mypy --show-column-numbers --follow-imports silent',
  lintFormats = {
    '%f:%l:%c: %trror: %m',
    '%f:%l:%c: %tarning: %m',
    '%f:%l:%c: %tote: %m'
  },
  lintIgnoreExitCode = true,
  lintSource = 'mypy',
}
local isort = {
        formatCommand = "isort --profile black -",
        formatStdin = true,
}
M.efm = {
  flake8,
  mypy,
  black,
  isort,
}

M.all_format = { efm = 'Black' }

M.default_format = 'efm'

M.lsp = {
    cmd = { home .. '/.pyenv/versions/neovim3/bin/pylsp' },
    capabilities = lsp.capabilities,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        lsp.post_attach(client)
    end,
}

return M
