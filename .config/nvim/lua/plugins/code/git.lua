local noremap = { noremap = true }
local M = {
	{
		"tpope/vim-fugitive",
		cmd = "G",
		keys = {
			{ "<leader>gd", "<cmd>Gdiffsplit<CR>", mode = "n", noremap },
		},
		config = function()
			local augroup = vim.api.nvim_create_augroup("FugitiveSmartQ", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = augroup,
				pattern = { "fugitive-summary", "fugitiveblame", "fugitive" },
				command = "nmap <buffer> q gq",
			})
			vim.api.nvim_create_autocmd("BufEnter", {
				group = augroup,
				pattern = "fugitive://*",
				command = "nmap <buffer> q :close<CR>",
			})
		end,
	},
	{
		"tpope/vim-rhubarb",
		dependencies = {
			"tpope/vim-fugitive",
		},
		event = "VeryLazy",
	},
	{
		"barrettruth/diffs.nvim",
		event = "VeryLazy",
	},
}

return M
