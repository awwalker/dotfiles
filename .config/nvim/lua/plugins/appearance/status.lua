local M = {
	{
		"statuscol",
		name = "statuscol",
		dir = vim.fn.stdpath("config") .. "/lua",
		lazy = false,
		priority = 1000,
		config = function()
			-- Enable sign column
			vim.opt.signcolumn = "yes"
			
			-- Set up the custom statuscolumn
			vim.opt.statuscolumn = [[%!v:lua.Status.statuscolumn()]]
			
			-- Enable folding with treesitter
			vim.opt.foldexpr = "v:lua.Status.foldexpr()"
			vim.opt.foldtext = ""
		end,
	},
}

return M
