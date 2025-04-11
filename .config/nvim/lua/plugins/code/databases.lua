local noremap = { noremap = true }

local M = {
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			"kristijanhusak/vim-dadbod-ui",
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
			"pbogut/vim-dadbod-ssh",
		},
		keys = {
			{ "<leader>db", "<cmd> DBUIToggle<CR>", mode = "n", noremap },
			{ "<leader>df", "<cmd> DBUIFindBuffer<CR>", mode = "n", noremap },
			{ "<leader>dl", "<cmd> DBUILastQueryInfo<CR>", mode = "n", noremap },
			{ "<localleader>db", "<cmd>vsp ~/.local/share/db_ui/connections.json<CR>", mode = "n", noremap },
		},
	},
}

return M
