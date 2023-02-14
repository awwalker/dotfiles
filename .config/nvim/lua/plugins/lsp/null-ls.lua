local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  config = function()
    local nls = require("null-ls")
    nls.setup({
      debounce = 150,
      save_after_format = false,
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
      -- DOCKER
      nls.builtins.diagnostics.hadolint.with(require("lsp2.docker.nls")),
      -- LUA
      nls.builtins.formatting.stylua.with(),
    })
  end,
}

return M
