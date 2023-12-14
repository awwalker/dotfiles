local noremap = { noremap = true }

local M = {
	{
		"nvim-neotest/neotest",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "antoinemadec/FixCursorHold.nvim" },
			{
				"nvim-neotest/neotest-python",
				ft = { "python" },
				dependencies = {
					{ "nvim-treesitter/nvim-treesitter" },
				},
			},
		},
		ft = { "python" },
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
					}),
				},
			})
		end,
		init = function()
			vim.api.nvim_set_keymap(
				"n",
				"<localleader>rt",
				"<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
				noremap
			)
		end,
		keys = {
			{ "<localleader>ts", '<cmd>lua require("neotest").summary.toggle()<CR>', mode = "n", noremap },
		},
	},
}

return M
