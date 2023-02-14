local M = {
  "neovim/nvim-lspconfig",
  event = "BufPreRead",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lsp = require("plugins.lsp2.lsp")
    lsp.setup()
    local lspconfig = require("lspconfig")
    lspconfig.docker.setup(require("plugins.lsp2.docker").lsp)
  end,
}
