local M = {
	"bbenzikry/snazzybuddy.nvim",
	dependencies = {
		"tjdevries/colorbuddy.nvim",
	},
	lazy = false,
	priority = 1000,
	config = function()
		local colorbuddy = require("colorbuddy")
		colorbuddy.colorscheme("snazzybuddy")
		vim.g.snazzybuddy_icons = true
	end,
}

return M
