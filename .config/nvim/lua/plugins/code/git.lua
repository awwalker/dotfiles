local noremap = { noremap = true }
local M = {
	{
		"tpope/vim-fugitive",
		cmd = "G",
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
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		keys = {
			{ "<leader>gd", "<cmd>:CodeDiff main...<CR>", mode = "n", noremap },
		},
		opts = {
			explorer = {
				focus_on_select = true,
			},
		},
	},
}

return M
