local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "FileType",
	config = function()
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({
			ensure_installed = {
				"python",
				"clojure",
				"go",
				"lua",
				"java",
				"gitignore",
				"terraform",
			},
			highlight = {
				enabled = false,
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
