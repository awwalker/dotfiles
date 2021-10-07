-- =============================
--          COMPLETION
-- =============================
vim.o.completeopt = 'menuone,noselect'
local cmp = require("cmp")

cmp.setup({
  snippet = {
  	expand = function(args)
  		require('luasnip').lsp_expand(args.body)
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
    { name = 'luasnip' },
  },
  formatting = {
  	format = function(entry, vim_item)
  		-- fancy icons and a name of kind
  		vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

  		-- set a name for each source
  		vim_item.menu = ({
  			nvim_lsp = "[LSP]",
       luasnip = "[Snippet]",
  			path = "[Path]",
  			buffer = "[Buffer]",
  			nvim_lua = "[Lua]",
  		})[entry.source.name]
  		return vim_item
  	end,
  },
})
