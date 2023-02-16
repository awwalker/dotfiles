local noremap = { noremap = true }

local M = {
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = "DBUI",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
			"pbogut/vim-dadbod-ssh",
		},
		keys = {
			{ "<leader>du", "<cmd> DBUIToggle<CR>", mode = "n", noremap },
			{ "<leader>df", "<cmd> DBUIFindBuffer<CR>", mode = "n", noremap },
			{ "<leader>dl", "<cmd> DBUILastQueryInfo<CR>", mode = "n", noremap },
			{ "<localleader>db", "<cmd>vsp ~/.local/share/db_ui/connections.json<CR>", mode = "n", noremap },
		},
	},
}

return M
