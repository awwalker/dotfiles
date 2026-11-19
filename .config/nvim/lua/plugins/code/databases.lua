local noremap = { noremap = true }

-- Cancel any in-flight async dadbod queries. dadbod stores the running job on
-- the output (.dbout) buffer's `b:db`, so `db#cancel()` only works from there
-- (it already binds <C-c> in that buffer). This scans every buffer for one with
-- a live job and cancels it, so it works from the SQL query buffer too.
local function dadbod_cancel_queries()
	local canceled = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local ok, db = pcall(function()
			return vim.b[buf].db
		end)
		if ok and type(db) == "table" and db.job ~= nil then
			vim.fn["db#cancel"](buf)
			canceled = canceled + 1
		end
	end
	if canceled == 0 then
		vim.notify("dadbod: no running query to cancel", vim.log.levels.INFO)
	else
		vim.notify(("dadbod: canceled %d quer%s"):format(canceled, canceled == 1 and "y" or "ies"), vim.log.levels.INFO)
	end
end

-- Vimscript side of the reconnect: operate directly on vim-dadbod-ui's internal
-- dicts. This can't be done from Lua because `db_ui#drawer#get()` returns a COPY
-- of the dict (funcrefs and all), so mutating it in Lua wouldn't touch the
-- plugin's real state. Defined once at load; the body is only parsed now and the
-- db#/db_ui# autoload calls resolve at call time.
--
-- Why each step is needed: DBUI resolves an `ssh://` url exactly once (via
-- vim-dadbod-ssh's canonicalize, which opens the tunnel and rewrites the url to
-- `postgresql://...@127.0.0.1:<port>/...`), then caches that resolved string in
-- `db.conn` and in every query buffer's `b:db`. The resolved string has no
-- `ssh://` prefix, so later queries never re-run tunnel resolution -- killing the
-- ssh process alone leaves every buffer pointed at a dead port. So we must drop
-- the cached conn, rebuild the tunnel ourselves, reconnect, and repoint buffers.
vim.cmd([[
function! DadbodSSHReconnectActive() abort
	let l:drawer = db_ui#drawer#get()
	if type(l:drawer) != v:t_dict || empty(l:drawer)
		return 'noui'
	endif
	let l:dbs = l:drawer.dbui.dbs
	" Only touch ssh connections that are actually connected (conn cached).
	let l:changed = []
	for l:key in keys(l:dbs)
		if l:dbs[l:key].url =~? '^ssh:' && !empty(l:dbs[l:key].conn)
			call add(l:changed, l:key)
		endif
	endfor
	if empty(l:changed)
		return 'none'
	endif
	for l:key in l:changed
		let l:db = l:dbs[l:key]
		" Forget the stale canonicalized connection so DBUI rebuilds it.
		let l:db.conn = ''
		let l:db.conn_tried = 0
		let l:db.conn_error = ''
		" Re-open the tunnel synchronously (v:false = blocking) so the port is
		" listening before db#connect runs its probe query -- postgres has no
		" auth_input short-circuit, so that probe really hits the tunnel.
		call db#adapter#ssh#create_tunnel(l:db.url, v:false)
		call l:drawer.dbui.connect(l:db)
	endfor
	" b:db is captured once at buffer creation and never refreshed, so repoint
	" every open query buffer at the freshly resolved connection.
	for l:info in getbufinfo()
		let l:k = getbufvar(l:info.bufnr, 'dbui_db_key_name', '')
		if !empty(l:k) && index(l:changed, l:k) >= 0
			call setbufvar(l:info.bufnr, 'db', l:dbs[l:k].conn)
		endif
	endfor
	call l:drawer.render({'dbs': 1, 'queries': 1})
	return len(l:changed)
endfunction
]])

-- Scan for live vim-dadbod-ssh tunnels, uniquely identified by the remote
-- `echo ssh_connected` marker in their command line.
local function ssh_tunnel_pids()
	local pids = vim.fn.systemlist({ "pgrep", "-f", "echo ssh_connected" })
	if vim.v.shell_error ~= 0 then
		return {}
	end
	return pids
end

-- Reconnect a dadbod-ssh connection whose tunnel has gone stale. Kill the ssh
-- process (its on_exit clears the plugin's s:tunnels cache), wait for it to die
-- so the cache is actually empty before we rebuild, then rebuild the tunnel,
-- drop DBUI's stale cached url, and repoint open buffers. Also handles the case
-- where the tunnel already died on its own (no process to kill but conn cached).
local function dadbod_ssh_refresh()
	local pids = ssh_tunnel_pids()
	for _, pid in ipairs(pids) do
		vim.fn.system({ "kill", pid })
	end
	-- vim.wait pumps the event loop, letting the job on_exit handlers run and
	-- clear s:tunnels before create_tunnel tries to reuse a dead entry.
	if #pids > 0 then
		vim.wait(3000, function()
			return #ssh_tunnel_pids() == 0
		end, 50)
	end
	local result = vim.fn.DadbodSSHReconnectActive()
	if result == "noui" then
		vim.cmd("DBUI")
		vim.notify("dadbod-ssh: opened DBUI; expand a connection to connect", vim.log.levels.INFO)
	elseif result == "none" then
		vim.notify("dadbod-ssh: no connected ssh database to refresh", vim.log.levels.INFO)
	else
		vim.notify(
			("dadbod-ssh: reconnected %s ssh database%s")
				:format(result, tonumber(result) == 1 and "" or "s"),
			vim.log.levels.INFO
		)
	end
end

local M = {
	{
		"pbogut/vim-dadbod-ssh",
		init = function()
			vim.g["db_ssh_default_async"] = true
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		dependencies = {
			-- Track master (not the v1.4 tag) for async query execution, which
			-- fires the User DBExecutePre/DBExecutePost events the statusline
			-- spinner hooks into. `version = false` overrides lazy's `version = "*"`.
			{ "tpope/vim-dadbod", lazy = true, branch = "master", version = false },
			"kristijanhusak/vim-dadbod-ui",
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
			"pbogut/vim-dadbod-ssh",
		},
		keys = {
			{ "<leader>db", "<cmd> DBUIToggle<CR>", mode = "n", noremap },
			{ "<leader>df", "<cmd> DBUIFindBuffer<CR>", mode = "n", noremap },
			{ "<leader>dl", "<cmd> DBUILastQueryInfo<CR>", mode = "n", noremap },
			{ "<leader>dc", dadbod_cancel_queries, mode = "n", desc = "Cancel running DB query(ies)" },
			{ "<leader>dr", dadbod_ssh_refresh, mode = "n", desc = "Reconnect dadbod SSH tunnel" },
			{ "<localleader>db", "<cmd>vsp ~/.local/share/db_ui/connections.json<CR>", mode = "n", noremap },
		},
	},
}

return M
