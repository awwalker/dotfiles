local M = {
	{
		"bezhermoso/tree-sitter-ghostty",
		build = "make nvim_install",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		version = false,
		config = function()
			local configs = require("nvim-treesitter.configs")
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
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
			parser_config.ghostty = {
				install_info = {
					url = "https://github.com/bezhermoso/tree-sitter-ghostty",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "ghostty",
			}
		end,
	},
}
return M
