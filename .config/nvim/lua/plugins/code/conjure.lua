local noremap = { noremap = true }

local M = {
	{
		"Olical/conjure",
		ft = { "clojure", "edn", "lua", "python", "fennel", "javascript" },
		keys = {
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
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "clj -M:repl/conjure"
			vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
			vim.g["conjure#client#clojure#nrepl#eval#print_function"] = "cider.nrepl.pprint/pprint"
			-- vim.g["conjure#log#hud#open_when"] = "log-win-not-visible"
			vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.nfnl"
			-- vim.g["conjure#debug"] = true
			vim.api.nvim_create_autocmd({ "BufNewFile" }, {
				group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
				pattern = "conjure-log-*",
				callback = function(params)
					for i, ns in pairs(vim.diagnostic.get_namespaces()) do
						vim.diagnostic.reset(i, 0)
					end
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

			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("ConjureSmartB", { clear = true }),
				pattern = "conjure-log-*",
				callback = function(params)
					vim.api.nvim_set_keymap("n", "B", "^", noremap)
				end,
			})
			vim.api.nvim_set_keymap("n", "<leader>c", "<cmd> ConjureCljDebugInput continue<CR>", noremap)
			vim.api.nvim_set_keymap("n", "<leader>n", "<cmd> ConjureCljDebugInput next<CR>", noremap)
			vim.api.nvim_set_keymap("n", "<localleader>rt", "<cmd> ConjureCljRunCurrentTest<Cr>", noremap)
			vim.api.nvim_set_keymap("n", "<localleader>rns", "<cmd> ConjureCljRunCurrentNsTests<Cr>", noremap)
		end,
	},
	{ "Olical/nfnl", ft = "fennel" },
	{ "jaawerth/fennel.vim", ft = "fennel" },
	{
		dir = "/Users/aaronwalker/oss/conjure-deno",
		ft = { "javascript", "typescript" },
		dependencis = { "Olical/conjure", { "Olical/aniseed", branch = "master" } },
	},
}

return M
