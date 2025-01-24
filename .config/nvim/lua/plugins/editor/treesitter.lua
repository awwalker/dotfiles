local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	version = false,
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"python",
				"clojure",
				"go",
				"lua",
				"java",
				"gitignore",
				"terraform",
				"norg",
				"vim",
				"typescript",
				"javascript",
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
		})
	end,
}
return M
