local M = {
	"anuvyklack/windows.nvim",
	event = "WinNew",
	dependencies = {
		{ "anuvyklack/middleclass" },
	},
	keys = { { "<leader>z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
	config = function()
		vim.o.winwidth = 5
		vim.o.equalalways = false
		require("windows").setup({})
	end,
}

return M
