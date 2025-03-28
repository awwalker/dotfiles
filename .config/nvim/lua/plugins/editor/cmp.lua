local M = {
	{
		"hrsh7th/nvim-cmp",
		commit = "29fb485",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				"rcarriga/cmp-dap",
				dependencies = {
					"mfussenegger/nvim-dap",
				},
				ft = { "dap-repl", "dapui_watches", "dapui_hover" },
			},
			{
				"PaterJason/cmp-conjure",
				dependencies = {
					"Olical/conjure",
					ft = { "clojure" },
				},
			},
			"kristijanhusak/vim-dadbod-completion",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
					autocomplete = false,
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				experimental = {
					ghost_text = true,
				},
				window = {
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
					}),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "conjure" },
					{ name = "neorg" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "cmdline" },
					{ name = "path" },
					{ name = "vim-dadbod-completion" },
				}),
				mapping = cmp.mapping.preset.insert({
					["<c-k>"] = cmp.mapping.scroll_docs(-4),
					["<c-j>"] = cmp.mapping.scroll_docs(4),
					["<c-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
					["<c-c>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
					["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
					["<Down>"] = cmp.mapping(
						cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
						{ "i", "c" }
					),
					["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "c" }),
					["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
				}),
			})
			cmp.setup.cmdline("/", {
				view = {
					entries = { name = "wildmenu" },
				},
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline("?", {
				view = {
					entries = { name = "wildmenu" },
				},
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man" },
						},
					},
				}),
			})
		end,
	},
	{
		"hrsh7th/cmp-nvim-lua",
		event = { "InsertEnter" },
		ft = "lua",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
}

return M
