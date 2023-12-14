local noremap = { noremap = true }

local M = {
	{
		"mfussenegger/nvim-dap",
		ft = { "python" },
		keys = {
			{ "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", mode = "n", noremap },
		},
		config = function()
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "", numhl = "" })
			vim.api.nvim_set_keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", noremap)
			vim.api.nvim_set_keymap("n", "<leader>c", "<cmd>lua require'dap'.continue()<CR>", noremap)
			vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>lua require'dap'.step_over()<CR>", noremap)
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = { "python" },
		dependencies = {
			{ "mfussenegger/nvim-dap" },
		},
		config = function()
			require("dap-python").setup("/Users/aaronwalker/.pyenv/shims/python")
			require("dap-python").test_runner = "pytest"
		end,
	},
}

return M
