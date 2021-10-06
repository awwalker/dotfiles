-- =============================
--          LSPs
-- =============================
local lsp = require("lspconfig")

-- lsp.dockerls.setup(require("languages.docker").lsp)
-- lsp.gopls.setup(require("languages.go").lsp)
lsp.sumneko_lua.setup(require("languages.lua").lsp)
-- lsp.pylsp.setup(require('languages.python').pylsp)
-- lsp.pyright.setup(require("languages.python").lsp)
-- lsp.yamlls.setup(require("languages.yaml").lsp)
-- lsp.jsonls.setup(require("languages.json").lsp)
-- lsp.tsserver.setup(require("languages.typescript").lsp)
-- lsp.efm.setup(require("languages.efm").lsp)
