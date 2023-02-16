local M = {
	"nvim-neorg/neorg",
	ft = "norg",
	build = "Neorg sync-parsers",
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
			["core.norg.dirman"] = {
				config = {
					workspaces = {
						work = "~/notes/work",
						tabletop = "~/notes/tabletop",
					},
				},
			},
			["core.norg.concealer"] = {},
			["core.norg.esupports.indent"] = {},
			["core.norg.journal"] = {},
			["core.norg.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
		},
	},
}

return M
