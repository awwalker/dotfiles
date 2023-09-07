local M = {
	{
		"christianchiarulli/nvcode-color-schemes.vim",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
		},
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.nvcode_termcolors = 256
			vim.cmd([[ color snazzy ]])
			vim.o.termguicolors = true
			vim.o.syntax = "on"
			vim.g.background = "dark"
		end,
	},
}

return M
