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
			{ "<localleader>db", "<cmd>vsp ~/.local/share/db_ui/connections.json<CR>", mode = "n", noremap },
		},
	},
}

return M
