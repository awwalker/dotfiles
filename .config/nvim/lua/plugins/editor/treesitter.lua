local M = {
	{
		"bezhermoso/tree-sitter-ghostty",
		build = "make nvim_install",
	},
	{
		"srazzak/tree-sitter-mdx",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		version = false,
		init = function()
			local ensureInstalled = {
				"python",
				"clojure",
				"go",
				"lua",
				"java",
				"gitignore",
				"terraform",
				"tsx",
				"vim",
				"typescript",
				"javascript",
				"markdown",
				"markdown_inline",
				"xml",
			}
			local alreadyInstalled = require("nvim-treesitter.config").get_installed()
			local parsersToInstall = vim
				.iter(ensureInstalled)
				:filter(function(parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()
			require("nvim-treesitter").install(parsersToInstall)
		end,
	},
}
return M
