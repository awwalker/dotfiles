local noremap = { noremap = true }
local M = {
	{
		"tpope/vim-fugitive",
		-- tpope rarely tags; the latest tag (v3.7, 2022) is ~190 commits behind master.
		version = false,
		cmd = "G",
		keys = {
			{
				"<leader>gc",
				"<cmd>G commit<CR>",
				mode = "n",
				desc = "Git commit (14-line window)",
			},
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
			-- Fix the `:G` status window at 14 lines (matches the commit window):
			-- a stable, comfortable height regardless of how many changes there are,
			-- scrollable when longer. When the buffer overflows, the lualine
			-- statusline shows a "scroll for more" indicator.
			vim.api.nvim_create_autocmd("FileType", {
				group = augroup,
				pattern = "fugitive",
				callback = function()
					vim.cmd("resize 14")
				end,
			})
			-- Size the commit message window to 14 lines. Fugitive opens it
			-- asynchronously, so resize on FileType (once the buffer exists)
			-- rather than inline after `:G commit`, which hits the wrong window.
			vim.api.nvim_create_autocmd("FileType", {
				group = augroup,
				pattern = "gitcommit",
				callback = function()
					-- Only when it's a split (skip when nvim is the sole $EDITOR window).
					if vim.fn.winnr("$") > 1 then
						vim.cmd("resize 14")
					end
				end,
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
