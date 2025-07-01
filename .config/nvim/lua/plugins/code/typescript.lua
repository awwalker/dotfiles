local M = {
	{
		"Sebastian-Nielsen/better-type-hover",
		ft = { "typescript", "typescriptreact" },
		config = function()
			local hover = require("better-type-hover")
			hover.setup({})
		end,
	},
}
return M
