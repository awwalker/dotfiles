-- =============================
--          COMPLETION
-- =============================
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noinsert",
		autocomplete = false,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<c-k>"] = cmp.mapping.scroll_docs(-4),
		["<c-j>"] = cmp.mapping.scroll_docs(4),
		["<c-Space>"] = cmp.mapping.complete(),
		["<c-c>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "conjure" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "luasnip" },
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
		}),
	},
	view = {
		entries = "native",
	},
})
