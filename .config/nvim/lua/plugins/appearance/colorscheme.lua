local M = {
	"christianchiarulli/nvcode-color-schemes.vim",
	dependencies = {},
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.nvcode_termcolors = 256
		vim.cmd([[ color snazzy ]])
	end,
}

return M
