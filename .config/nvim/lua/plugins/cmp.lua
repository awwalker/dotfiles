-- =============================
--          COMPLETION
-- =============================
vim.o.completeopt = "menu,menuone,noselect"
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<c-j>"] = cmp.mapping.scroll_docs(-4),
		["<c-k>"] = cmp.mapping.scroll_docs(4),
		["<c-Space>"] = cmp.mapping.complete(),
		["<c-c>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "luasnip" },
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			-- before = function (entry, vim_item)
			-- --   ...
			-- --   return vim_item
			-- -- end
			-- -- set a name for each source
			--   vim_item.menu = ({
			--   	nvim_lsp = "[LSP]",
			--   	luasnip = "[Snippet]",
			--   	path = "[Path]",
			--   	buffer = "[Buffer]",
			--   	nvim_lua = "[Lua]",
			--   })[entry.source.name]
			--   return vim_item
			-- end
		}),
	},
})
