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
			vim.g["conjure#eval#gsubs"] = { ["comment"] = { "^%(comment[%s%c]", "(do " } }
			-- autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)
			vim.api.nvim_create_autocmd("BufNewFile", {
				group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
				pattern = "conjure-log-*",
				callback = function(params)
					vim.diagnostic.disable(0)
				end,
			})
			-- autocmd User ConjureEval if expand("%:t") =~ "^conjure-log-" | exec "normal G" | endif
			vim.api.nvim_create_autocmd("User", {
				group = vim.api.nvim_create_augroup("ConjureEval", { clear = true }),
				pattern = "ConjureEval",
				callback = function(params)
					if string.match(vim.api.nvim_buf_get_name(0), "conjure%-log%-") then
						vim.api.nvim_exec([[normal G]], true)
					end
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ConjureSmartQ", { clear = true }),
				pattern = "conjure-log-*",
				command = "nmap <buffer> q gq",
			})
		end,
	},
	{
		"Invertisment/conjure-clj-additions-cider-nrepl-mw",
		ft = { "clojure" },
		cmd = { "CcaNreplRunTestsInTestNs", "CcaNreplRunCurrentTest", "CcaNreplJumpToFailingCljTest" },
		keys = {
			{ "<localleader>rns", "<cmd>CcaNreplRunTestsInTestNs<CR>", mode = "n", noremap },
			{ "<localleader>rt", "<cmd>CcaNreplRunCurrentTest<CR>", mode = "n", noremap },
		},
	},
	{ "Olical/aniseed" },
	{ "bakpakin/fennel.vim" },
}

return M
