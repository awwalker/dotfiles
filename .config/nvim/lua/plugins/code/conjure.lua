local noremap = { noremap = true }

local M = {
	{
		"Olical/conjure",
		ft = { "clojure", "edn", "lua", "python" },
		keys = {
			{ "<leader>c", "<cmd> ConjureCljDebugInput continue<CR>", mode = "n", noremap },
			{ "<leader>n", "<cmd> ConjureCljDebugInput next<CR>", mode = "n", noremap },
			{ "<leader>de", "<cmd> ConjureCljDebugInput eval<CR>", mode = "n", noremap },
			{ "<leader>di", "<cmd> ConjureCljDebugInit<CR>", mode = "n", noremap },
			{ "<leader>le", "<cmd> ConjureCljLastException<CR>", mode = "n", noremap },
			{ "<leader>ll", "<cmd> ConjureCljDebugInput local<CR>", mode = "n", noremap },
			{ "<leader>si", "<cmd> ConjureCljDebugInput in<CR>", mode = "n", noremap },
			{ "<leader>so", "<cmd> ConjureCljDebugInput out<CR>", mode = "n", noremap },
		},
		config = function()
			require("conjure.main").main()
			require("conjure.mapping")["on-filetype"]()
		end,
		init = function()
			vim.g["conjure#eval#gsubs"] = { ["comment"] = { "^%(comment[%s%c]", "(do " } }
			vim.api.nvim_create_autocmd("BufNewFile", {
				group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
				pattern = "conjure-log-*",
				callback = function(params)
					vim.diagnostic.disable(0)
				end,
			})
			-- autocmd User ConjureEval if expand("%:t") =~ "^conjure-log-" | exec "normal G" | endif
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("ConjureEval", { clear = true }),
				pattern = "conjure-log-*",
				callback = function(params)
					if string.match(vim.api.nvim_buf_get_name(0), "conjure%-log%-") then
						vim.api.nvim_exec([[normal G]], true)
					end
				end,
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("ConjureSmartQ", { clear = true }),
				pattern = "conjure-log-*",
				command = "nmap <buffer> q :q<CR>",
			})
		end,
	},
	{
		"https://gitlab.com/invertisment/conjure-clj-additions-cider-nrepl-mw.git",
		ft = { "clojure" },
		cmd = { "CcaNreplRunTestsInTestNs", "CcaNreplRunCurrentTest", "CcaNreplJumpToFailingCljTest" },
		keys = {
			{ "<localleader>rns", "<cmd>CcaNreplRunTestsInTestNs<CR>", mode = "n", noremap },
			{ "<localleader>rt", "<cmd>CcaNreplRunCurrentTest<CR>", mode = "n", noremap },
			{ "<localleader>rft", "<cmd>CcaNreplJumpToFailingCljTest<CR>", mode = "n", noremap },
		},
	},
	{ "Olical/aniseed" },
	{ "bakpakin/fennel.vim" },
}

return M
