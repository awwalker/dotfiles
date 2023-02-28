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
			keys = {
				{ "." },
				{ "cs" },
			},
		},
	},
	{
		"chentoast/marks.nvim",
		cmd = "MarksToggleSigns",
		event = "VeryLazy",
		config = function()
			local marks = require("marks")
			marks.setup({
				mappings = {
					toggle = "mm",
					prev = "<localleader>m",
					next = "<leader>m",
				},
				builtin_marks = { ".", "<", ">", "^" },
			})
		end,
	},
	{
		"ellisonleao/glow.nvim",
		event = "VeryLazy",
		cmd = "Glow",
		version = false,
		config = function()
			local glow = require("glow")
			glow.setup()
		end,
	},
}

return M
