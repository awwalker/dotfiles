local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	pin = true,
	version = false,
	lazy = false,
	opts = {
		ensure_installed = {
			"python",
			"clojure",
			"go",
			"lua",
			"java",
			"gitignore",
			"terraform",
			"norg",
		},
		highlight = {
			enabled = true,
		},
		indent = {
			enable = false,
		},
		pairs = {
			enable = true,
			highlight_self = false,
			goto_right_end = false,
			fallback_cmd_normal = "normal! %",
		},
	},
	config = function(_, opts)
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup(opts)
	end,
}

return M
