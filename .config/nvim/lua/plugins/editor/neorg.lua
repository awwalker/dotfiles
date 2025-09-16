local M = {
	"nvim-neorg/neorg",
	ft = "norg",
	lazy = false,
	-- removed for https://github.com/nvim-neorg/neorg/issues/1342
	-- build = ":Neorg sync-parsers",
	version = "*",
	cmd = "Neorg",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "benlubas/neorg-interim-ls" },
	},
	opts = {
		load = {
			["core.defaults"] = {},
			["core.autocommands"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						work = "~/notes/work",
						tabletop = "~/notes/tabletop",
					},
				},
			},
			["core.concealer"] = {},
			["core.export.markdown"] = {},
			["core.export"] = {},
			["external.interim-ls"] = {},
			["core.completion"] = {
				config = {
					engine = { module_name = "external.lsp-completion" },
				},
			},
		},
	},
}

return M
