local M = {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		branch = "master",
		ft = { "javascript", "typescript", "tsx" },
		keys = {
			{
				"<leader>tt",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
				mode = "n",
				noremap = true,
				desc = "Run test file",
			},
			{
				"<localleader>rt",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
				mode = "n",
				noremap = true,
				desc = "Run test file",
			},
			{
				"<leader>tn",
				"<cmd>lua require('neotest').run.run()<CR>",
				mode = "n",
				noremap = true,
				desc = "Run nearest test",
			},
			{
				"<leader>to",
				"<cmd>lua require('neotest').output.open({ enter = true, auto_close = true })<CR>",
				mode = "n",
				noremap = true,
				desc = "Show test output",
			},
			{
				"<leader>tp",
				"<cmd>lua require('neotest').output_panel.toggle()<CR>",
				mode = "n",
				noremap = true,
				desc = "Toggle output panel",
			},
			{
				"<leader>ts",
				"<cmd>lua require('neotest').summary.toggle()<CR>",
				mode = "n",
				noremap = true,
				desc = "Toggle test summary",
			},
			{
				"<leader>tw",
				"<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>",
				mode = "n",
				noremap = true,
				desc = "Toggle watch mode",
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
		},
		config = function()
			-- Define highlight groups BEFORE setup
			vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#00ff00", bold = true })
			vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#ff0000", bold = true })
			vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#ffff00", bold = true })
			vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#00ffff", bold = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("NeotestSmartQ", { clear = true }),
				pattern = "Neotest Summary",
				command = "nmap <buffer> q :q<CR>",
			})

			require("neotest").setup({
				adapters = {
					require("neotest-vitest")({
						-- Set the vitest command - let the adapter find the local binary
						-- The adapter will look for node_modules/.bin/vitest automatically
						vitestCommand = function(path)
							-- Find the workspace root by looking for vitest.config.js
							local root = vim.fs.dirname(vim.fs.find({ "vitest.config.js", "vitest.config.ts" }, {
								path = path,
								upward = true,
							})[1])

							if root then
								-- Use the local vitest binary from the workspace
								local local_vitest = root .. "/node_modules/.bin/vitest"
								if vim.fn.filereadable(local_vitest) == 1 then
									return local_vitest
								end
							end

							-- Fallback to npx vitest
							return "npx vitest"
						end,

						-- Set the config file path dynamically
						vitestConfigFile = function(path)
							local configs = vim.fs.find({ "vitest.config.js", "vitest.config.ts" }, {
								path = path,
								upward = true,
							})
							return configs[1]
						end,

						-- Set cwd to the workspace root
						cwd = function(path)
							local root = vim.fs.dirname(vim.fs.find({ "vitest.config.js", "vitest.config.ts" }, {
								path = path,
								upward = true,
							})[1])
							return root
						end,

						-- Filter test files
						is_test_file = function(file_path)
							return file_path:match("%.test%.ts$")
								or file_path:match("%.test%.tsx$")
								or file_path:match("%.spec%.ts$")
								or file_path:match("%.spec%.tsx$")
						end,

						-- Exclude node_modules
						filter_dir = function(name)
							return name ~= "node_modules"
						end,
					}),
				},

				-- Enable debug logging temporarily
				log_level = vim.log.levels.DEBUG,

				-- Configure output
				output = {
					enabled = true,
					open_on_run = true,
				},

				-- Configure output panel
				output_panel = {
					enabled = true,
					open = "botright split | resize 15",
				},

				-- THIS IS THE KEY FIX - Configure status display properly
				status = {
					enabled = true,
					virtual_text = true, -- Enable virtual text to show status inline
					signs = true, -- Enable signs in sign column
				},

				-- Icons configuration
				icons = {
					passed = "✓",
					running = "⟳",
					failed = "✗",
					skipped = "○",
					unknown = "?",
					child_prefix = "├",
					child_indent = "│",
					final_child_prefix = "└",
					non_collapsible = "─",
					collapsed = "─",
					expanded = "╮",
					final_child_indent = " ",
					running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
				},

				-- Configure floating window
				floating = {
					border = "rounded",
					max_height = 0.6,
					max_width = 0.6,
				},

				-- Configure quickfix
				quickfix = {
					enabled = true,
					open = false,
				},

				-- Configure summary window
				summary = {
					enabled = true,
					animated = true,
					follow = true,
					expand_errors = true,
					mappings = {
						attach = "a",
						clear_marked = "M",
						clear_target = "T",
						debug = "d",
						debug_marked = "D",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						jumpto = "i",
						mark = "m",
						next_failed = "J",
						output = "o",
						prev_failed = "K",
						run = "r",
						run_marked = "R",
						short = "O",
						stop = "u",
						target = "t",
						watch = "w",
					},
				},

				-- Diagnostic configuration - CRITICAL FOR SHOWING FAILURES
				diagnostic = {
					enabled = true,
					severity = vim.diagnostic.severity.ERROR,
				},
			})
		end,
	},
}
return M
