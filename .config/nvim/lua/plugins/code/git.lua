local noremap = { noremap = true }
local M = {
	{
		"tpope/vim-fugitive",
		cmd = "G",
		keys = {
			{ "<leader>gd", "<cmd>Gdiffsplit<CR>", mode = "n", noremap },
		},
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("FugitiveSmartQ", { clear = true }),
				pattern = { "fugitive-summary", "fugitiveblame", "fugitive" },
				command = "nmap <buffer> q gq",
			})
		end,
	},
	{
		"tpope/vim-rhubarb",
		dependencies = {
			"tpope/vim-fugitive",
		},
		cmd = "GBrowse",
	},
}

return M
