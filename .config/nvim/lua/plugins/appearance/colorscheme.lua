local M = {
	-- {
	-- 	"christianchiarulli/nvcode-color-schemes.vim",
	-- 	dependencies = {
	-- 		{ "nvim-treesitter/nvim-treesitter" },
	-- 	},
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd([[ color snazzy ]])
	-- 		vim.o.syntax = "on"
	-- 		vim.g.background = "dark"
	-- 	end,
	-- },
	--
	{
		"maxmx03/dracula.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local dracula = require("dracula")

			dracula.setup({
				transparent = false,
				plugins = {
					["nvim-treesitter"] = true,
					["nvim-lspconfig"] = true,
					["nvim-cmp"] = true,
					["dashboard-nvim"] = true,
					["gitsigns.nvim"] = true,
					["lazy.nvim"] = true,
					["telescope.nvim"] = true,
					["hop.nvim"] = true,
				},
			})
			vim.cmd.colorscheme("dracula")
		end,
	},
}

return M
