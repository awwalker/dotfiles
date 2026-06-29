local M = {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		---@type snacks.Config
		opts = {
			picker = {
				layout = {
					preset = "telescope",
				},
			},
		},
		keys = {
			{
				"<c-f>",
				function()
					Snacks.picker.files()
				end,
				desc = "Files",
			},
			{
				"<c-g>",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			{
				"<leader>f",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>t",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer",
			},
			{
				"<c-b>",
				function()
					Snacks.picker.buffers({
						win = {
							input = {
								keys = {
									["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Buffers",
			},
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches({
						win = {
							input = {
								keys = {
									["<c-n>"] = { "git_branch_add", mode = { "n", "i" } },
									["<c-d>"] = { "git_branch_del", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Git branches",
			},
			{
				"<leader>r",
				function()
					Snacks.picker.lsp_references()
				end,
				desc = "LSP references",
			},
			{
				"<A-m>",
				function()
					Snacks.picker.marks({
						win = {
							input = {
								keys = {
									["<c-d>"] = { "mark_delete", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Marks",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
		},
	},
}

return M
