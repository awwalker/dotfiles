local M = {
	"nvim-neorg/neorg",
	ft = "norg",
	build = ":Neorg sync-parsers",
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
			-- config = {
			-- 	-- markup_preset = "dimmed",
			-- 	markup_preset = "conceal",
			-- 	icon_preset = "diamond",
			-- 	-- icon_preset = "varied",
			-- 	icons = {
			-- 		marker = {
			-- 			enabled = true,
			-- 			icon = " ",
			-- 		},
			-- 		todo = {
			-- 			enable = true,
			-- 			pending = {
			-- 				-- icon = ""
			-- 				icon = "",
			-- 			},
			-- 			uncertain = {
			-- 				icon = "?",
			-- 			},
			-- 			urgent = {
			-- 				icon = "",
			-- 			},
			-- 			on_hold = {
			-- 				icon = "",
			-- 			},
			-- 			cancelled = {
			-- 				icon = "",
			-- 			},
			-- 		},
			-- 		heading = {
			-- 			enabled = true,
			-- 			level_1 = {
			-- 				icon = "◈",
			-- 			},

			-- 			level_2 = {
			-- 				icon = " ◇",
			-- 			},

			-- 			level_3 = {
			-- 				icon = "  ◆",
			-- 			},
			-- 			level_4 = {
			-- 				icon = "   ❖",
			-- 			},
			-- 			level_5 = {
			-- 				icon = "    ⟡",
			-- 			},
			-- 			level_6 = {
			-- 				icon = "     ⋄",
			-- 			},
			-- 		},
			-- 	},
			-- },
			-- },
			["core.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
		},
	},
}

return M
