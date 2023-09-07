local noremap = { noremap = true }
local M = {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	cmd = "ToggleTerm",
	opts = {
		close_on_exit = true,
		start_in_insert = true,
		size = function(term)
			if term.direction == "horizontal" then
				return vim.o.lines * 0.25
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
	},
	keys = {
		{ "<c-t>", "<cmd>ToggleTerm<CR>", mode = "n", noremap },
	},
}

return M
