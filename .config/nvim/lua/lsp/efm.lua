local handlers = require("lsp.handlers")
local M = {}

M.lsp = {
  root_dir = vim.loop.cwd,
  filetypes = {
    -- "clojure", if efm ever supports clojure.
    "dockerfile",
    "go",
    "json",
    "latex",
    "lua",
    "markdown",
    "python",
    "typescript",
    "yaml",
  },

  init_options = { documentFormatting = true, codeAction = true, document_formatting = true },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      -- clojure = require("languages.clojure").efm, if efm ever supports clojure.
      dockerfile = require("lsp.languages.docker").efm,
      go = require("lsp.languages.go").efm,
      json = require("lsp.languages.json").efm,
      latex = require("lsp.languages.latex").efm,
      lua = require("lsp.languages.lua").efm,
      markdown = require("lsp.languages.markdown").efm,
      ["="] = require("lsp.languages.misspell").efm,
      python = require("lsp.languages.python").efm,
      typescript = require("lsp.languages.typescript").efm,
      yaml = require("lsp.languages.yaml").efm,
    },
  },
  on_attach = function(client)
    client.server_capabilities.document_formatting = true
    handlers.on_attach(client, 0)
  end,
  capabilities = handlers.capabilities,
}

return M
