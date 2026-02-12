local noremap = { noremap = true }
local M = {
	{
		"nvim-neotest/neotest",
		--commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
		ft = "typescript",
		keys = {
			{
				"<leader>tt",
				"<cmd> lua require('neotest').run.run({vim.fn.expand('%'), vitestCommand = 'turbo run test'})<CR>",
				mode = "n",
				noremap,
			},
			{
				"<localleader>rt",
				"<cmd> lua require('neotest').run.run({vim.fn.expand('%'), vitestCommand = 'turbo run test'})<CR>",
				mode = "n",
				noremap,
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
		},
		opts = {
			status = { virtual_text = true },
			output = { open_on_run = true },
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						-- Replace newline and tab characters with space for more compact diagnostics
						local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)
			vim.api.nvim_set_keymap(
				"n",
				"<localleader>rt",
				"<cmd> lua require('neotest').run.run({vim.fn.expand('%'), vitestCommand = 'turbo run test'})<CR>",
				noremap
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>tt",
				"<cmd> lua require('neotest').run.run({vim.fn.expand('%'), vitestCommand = 'turbo run test'})<CR>",
				noremap
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>to",
				"<cmd> lua require('neotest').output.open({ enter = true, auto_close = true })<CR>",
				noremap
			)
			vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd> lua require('neotest').summary.toggle()<CR>", noremap)
			require("neotest").setup({
				adapters = {
					require("neotest-vitest")({
						cwd = function(testFilePath)
							return vim.fs.root(testFilePath, "node_modules")
						end,
						filter_dir = function(name, rel_path, root)
							return name ~= "node_modules"
						end,
					}),
				},
			})
		end,
	},

	-- {
	-- 	"<leader>tT",
	-- 	function()
	-- 		require("neotest").run.run(vim.uv.cwd())
	-- 	end,
	-- 	desc = "Run All Test Files (Neotest)",
	-- },
	-- {
	-- 	"<leader>tr",
	-- 	function()
	-- 		require("neotest").run.run()
	-- 	end,
	-- 	desc = "Run Nearest (Neotest)",
	-- },
	-- {
	-- 	"<leader>tl",
	-- 	function()
	-- 		require("neotest").run.run_last()
	-- 	end,
	-- 	desc = "Run Last (Neotest)",
	-- },
	-- {
	-- 	"<leader>ts",
	-- 	function()
	-- 		require("neotest").summary.toggle()
	-- 	end,
	-- 	desc = "Toggle Summary (Neotest)",
	-- },
	-- {
	-- 	"<leader>to",
	-- 	function()
	-- 		require("neotest").output.open({ enter = true, auto_close = true })
	-- 	end,
	-- 	desc = "Show Output (Neotest)",
	-- },
	-- {
	-- 	"<leader>tO",
	-- 	function()
	-- 		require("neotest").output_panel.toggle()
	-- 	end,
	-- 	desc = "Toggle Output Panel (Neotest)",
	-- },
	-- {
	-- 	"<leader>tS",
	-- 	function()
	-- 		require("neotest").run.stop()
	-- 	end,
	-- 	desc = "Stop (Neotest)",
	-- },
	-- {
	-- 	"<leader>tw",
	-- 	function()
	-- 		require("neotest").watch.toggle(vim.fn.expand("%"))
	-- 	end,
	-- 	desc = "Toggle Watch (Neotest)",
	-- },
	-- 	},
}

return M
