-- =============================
--          LSPs
-- =============================
require("lsp.handlers").setup()

local lspconfig = require("lspconfig")
lspconfig.clojure_lsp.setup(require("lsp.languages.clojure").lsp)
lspconfig.dockerls.setup(require("lsp.languages.docker").lsp)
lspconfig.efm.setup(require("lsp.efm").lsp)
lspconfig.gopls.setup(require("lsp.languages.go").lsp)
lspconfig.jsonls.setup(require("lsp.languages.json").lsp)
lspconfig.pyright.setup(require("lsp.languages.python").lsp)
lspconfig.sumneko_lua.setup(require("lsp.languages.lua").lsp)
lspconfig.texlab.setup(require("lsp.languages.latex").lsp)
lspconfig.tsserver.setup(require("lsp.languages.typescript").lsp)
lspconfig.yamlls.setup(require("lsp.languages.yaml").lsp)
lspconfig.marksman.setup(require("lsp.languages.markdown").lsp)
lspconfig.lemminx.setup(require("lsp.languages.xml").lsp)
