local M = {
	require("plugins.editor.treesitter"),
	require("plugins.editor.cmp"),
	require("plugins.editor.telescope"),
	require("plugins.editor.gitsigns"),
	require("plugins.editor.leap"),
	require("plugins.editor.flit"),
	require("plugins.editor.neorg"),
	require("plugins.editor.autopairs"),
	require("plugins.editor.bufferline"),
	{
		"tpope/vim-surround",
		dependencies = {
			"tpope/vim-repeat",
		},
	},
	{
		"chentoast/marks.nvim",
		opts = {
			mappings = {
				set_next = "mm",
				next = "m[",
				prev = "m]",
			},
			builtin_marks = { ".", "<", ">", "^" },
		},
	},
}

return M
