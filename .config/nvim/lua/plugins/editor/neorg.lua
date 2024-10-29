local M = {
	"nvim-neorg/neorg",
	ft = "norg",
	-- removed for https://github.com/nvim-neorg/neorg/issues/1342
	-- build = ":Neorg sync-parsers",
	version = "*",
	cmd = "Neorg",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
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
			["core.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
		},
	},
}

return M
