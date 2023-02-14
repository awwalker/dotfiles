local M = {
  "neovim/nvim-lspconfig",
  lazy = false,
  priority = 1000,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lsp = require("lspconfig")
    local handlers = require("plugins.lsp.handlers")

    lsp.sumneko_lua.setup({
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities(),
      single_file_support = true,
      settings = require("plugins.lsp.lua").lsp,
    })
  end,
}

return M
