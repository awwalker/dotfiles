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
			-- Hightlight evaluated forms
			vim.g["conjure#highlight#enabled"] = true
			-- Show HUD REPL log at startup
			vim.g["conjure#log#hud#enabled"] = false
			-- vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true
			vim.g["conjure#client#clojure#nrepl#eval#auto_require"] = true
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "clj -M:repl/conjure"
			vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
			vim.g["conjure#client#clojure#nrepl#test#raw_out"] = true
			vim.g["conjure#client#clojure#nrepl#test#runner"] = "clojure"
			vim.g["conjure#client#clojure#nrepl#refresh#backend"] = "clj-reload"
			-- vim.g["conjure#client#clojure#nrepl#test#call_suffix"] = '{:config-file "tests.edn"}'
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

			-- After a Conjure refresh, rebuild the DB connection pool so the REPL
			-- reattaches to the current database. `shared.db.pool/datasource` is a
			-- top-level `def` from the treasuryprime/shared JAR, so clj-reload never
			-- recreates it — after an out-of-process `make db_migrate`/`db_rebuild`
			-- the pool stays bound to the old connections. `user/reset-db` (eval'd
			-- into the REPL, see below) closes the stale pool and rebuilds it.
			--
			-- Scoped buffer-locally (Conjure prefers b: over g: for config) to
			-- projects that depend on treasuryprime/shared, so refresh in other
			-- Clojure repos is unaffected.
			--
			-- Define this once per REPL session (e.g. from a gitignored scratch
			-- buffer) so `user/reset-db` resolves when the hook fires:
			--
			--   (ns user (:require [shared.db.pool :as pool] [core.db :as db]))
			--   (defn reset-db []
			--     (let [old   (:datasource pool/datasource)
			--           fresh (pool/datasource*)]
			--       (alter-var-root #'pool/datasource (constantly fresh))
			--       (alter-var-root #'db/datasource   (constantly fresh))
			--       (when (instance? java.io.Closeable old)
			--         (try (.close ^java.io.Closeable old) (catch Exception _)))
			--       (println ";; reset-db: reattached DB pool")
			--       :ok))
			local function uses_shared_db_pool()
				local root = vim.fs.root(0, "deps.edn")
				if not root then
					return false
				end
				local ok, lines = pcall(vim.fn.readfile, root .. "/deps.edn")
				if not ok then
					return false
				end
				return string.find(table.concat(lines, "\n"), "treasuryprime/shared", 1, true) ~= nil
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ConjureRefreshResetDb", { clear = true }),
				pattern = "clojure",
				callback = function()
					if uses_shared_db_pool() then
						vim.b["conjure#client#clojure#nrepl#refresh#after"] = "user/reset-db"
					end
				end,
			})
			-- Replace Conjure's `cf`: its auto-repl only starts if no auto-repl proc
			-- is already running in this Neovim, so after deleting .nrepl-port it
			-- silently does nothing. If there's no port file, restart the auto-repl
			-- (stops any stale one); otherwise connect as usual. nREPL writes
			-- .nrepl-port once it's up, and the next eval passively connects.
			vim.g["conjure#client#clojure#nrepl#mapping#connect_port_file"] = false
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ConjureConnectOrStart", { clear = true }),
				pattern = "clojure",
				callback = function(args)
					vim.keymap.set("n", "<localleader>cf", function()
						local port_files = vim.g["conjure#client#clojure#nrepl#connection#port_files"]
							or { ".nrepl-port", ".shadow-cljs/nrepl.port" }
						local found = vim.fs.find(port_files, { upward = true, path = vim.fn.expand("%:p:h") })[1]
						if found then
							require("conjure.client.clojure.nrepl.action")["connect-port-file"]()
						else
							require("conjure.client.clojure.nrepl.auto-repl")["restart-auto-repl-proc"]()
						end
					end, { buffer = args.buf, desc = "Conjure: connect via port file, or (re)start auto-repl" })
				end,
			})
			vim.api.nvim_set_keymap("n", "<leader>c", "<cmd> ConjureCljDebugInput continue<CR>", noremap)
			vim.api.nvim_set_keymap("n", "<leader>n", "<cmd> ConjureCljDebugInput next<CR>", noremap)
			vim.api.nvim_set_keymap(
				"n",
				"<localleader>rt",
				"<cmd>ConjureCljRefreshChanged<CR><cmd>ConjureCljRunCurrentTest<CR>",
				noremap
			)
			vim.api.nvim_set_keymap(
				"n",
				"<localleader>rns",
				"<cmd>ConjureCljRefreshChanged<CR><cmd>ConjureCljRunCurrentNsTests<CR>",
				noremap
			)
			-- Refresh changed namespaces, then rebuild the DB connection pool so the
			-- session re-attaches after an out-of-process `make db_migrate` (avoids
			-- stale pooled connections / "cached plan must not change result type").
			-- requiring-resolve keeps this a clean no-op error outside the core repo,
			-- and we best-effort close the old pool so repeated use doesn't leak it.
			local reconnect_db = table.concat({
				"(let [pv (requiring-resolve (quote shared.db.pool/datasource))",
				"build (requiring-resolve (quote shared.db.pool/datasource*))",
				"old (var-get pv)]",
				"(try (.close (:datasource old)) (catch Throwable _ nil))",
				"(alter-var-root pv (constantly (build)))",
				"(when-let [cv (resolve (quote core.db/datasource))]",
				"(alter-var-root cv (constantly (var-get pv))))",
				":db-reconnected)",
			}, " ")
			vim.keymap.set("n", "<localleader>rd", function()
				vim.cmd("ConjureCljRefreshChanged")
				vim.cmd("ConjureEval " .. reconnect_db)
			end, { desc = "Conjure: refresh + reconnect core DB pool" })
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
