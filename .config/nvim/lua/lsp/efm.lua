local lsp = require("languages.lsp")

require("lspconfig").efm.setup({
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

	init_options = { codeAction = true, document_formatting = true },
	settings = {
		rootMarkers = { ".git/" },
		languages = {
			-- clojure = require("languages.clojure").efm, if efm ever supports clojure.
			dockerfile = require("languages.docker").efm,
			go = require("languages.go").efm,
			json = require("languages.json").efm,
			latex = require("languages.latex").efm,
			lua = require("languages.lua").efm,
			markdown = require("languages.markdown").efm,
			["="] = require("languages.misspell").efm,
			python = require("languages.python").efm,
			typescript = require("languages.typescript").efm,
			yaml = require("languages.yaml").efm,
		},
	},
	on_attach = lsp.on_attach,
	capabilities = lsp.capabilities,
})
