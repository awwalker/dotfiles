local M = {
	{
		"folke/snacks.nvim",
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
									--["<c-s>"] = { "git_branch_add", mode = { "n", "i" } },
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
		},
	},
	{
		"2kabhishek/seeker.nvim",
		dependencies = { "folke/snacks.nvim" },
		cmd = "Seeker",
		setup = {
			picker_provider = "snacks",
			toggle_key = "<C-e>",
		},
		opts = {},
		keys = {
			{
				"<c-f>",
				"<cmd> Seeker files<CR>",
				desc = "Smart Find Files",
			},
			{
				"<leader>f",
				"<cmd> Seeker grep<CR>",
				desc = "Grep",
			},
			{
				"<c-g>",
				"<cmd> Seeker grep_word<CR>",
				desc = "Visual selection or word",
			},
		},
	},
}

return M
