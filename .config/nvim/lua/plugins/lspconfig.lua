-- =============================
--          LSPs
-- =============================
local lsp = require("lspconfig")

lsp.clojure_lsp.setup(require("languages.clojure").lsp)
lsp.dockerls.setup(require("languages.docker").lsp)
lsp.gopls.setup(require("languages.go").lsp)
lsp.jsonls.setup(require("languages.json").lsp)
lsp.pyright.setup(require("languages.python").lsp)
lsp.sumneko_lua.setup(require("languages.lua").lsp)
lsp.texlab.setup(require("languages.latex").lsp)
lsp.tsserver.setup(require("languages.typescript").lsp)
lsp.yamlls.setup(require("languages.yaml").lsp)
lsp.zeta_note.setup(require("languages.markdown").lsp)
