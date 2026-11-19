local M = {}

-- Run a git command (as a list, no shell) and return stdout lines + ok flag.
local function git(args)
	local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
	return out, vim.v.shell_error == 0
end

-- Parse `git worktree list --porcelain` into a list of items.
local function list_worktrees()
	local lines, ok = git({ "worktree", "list", "--porcelain" })
	if not ok then
		return {}
	end

	local items, cur = {}, nil
	for _, line in ipairs(lines) do
		if line:match("^worktree ") then
			cur = { worktree = line:sub(10) }
			table.insert(items, cur)
		elseif cur then
			if line:match("^HEAD ") then
				cur.head = line:sub(6)
			elseif line:match("^branch ") then
				cur.branch = line:sub(8):gsub("^refs/heads/", "")
			elseif line == "bare" then
				cur.bare = true
			elseif line == "detached" then
				cur.detached = true
			end
		end
	end
	return items
end

local function label(item)
	if item.bare then
		return "(bare)"
	elseif item.branch then
		return item.branch
	elseif item.detached then
		return "(detached " .. (item.head and item.head:sub(1, 8) or "?") .. ")"
	end
	return "(unknown)"
end

-- Given an absolute file path and a target worktree root, return the path to the
-- same-relative file in the target tree, or nil if there's no match. The
-- relative path is taken from the file's OWN worktree toplevel (via `git -C`), so
-- this works for any buffer regardless of which worktree it came from and stays
-- in that buffer's path namespace (important on macOS where cwd may be a symlink).
local function equivalent_in(name, new_root)
	if name == "" or vim.fn.filereadable(name) == 0 then
		return nil
	end
	local top, ok = git({ "-C", vim.fn.fnamemodify(name, ":h"), "rev-parse", "--show-toplevel" })
	if not ok or not top[1] then
		return nil
	end
	local old_root = top[1]
	if old_root == new_root then
		return nil -- already in the target tree
	end
	if name:sub(1, #old_root + 1) ~= old_root .. "/" then
		return nil
	end
	local rel = name:sub(#old_root + 2)
	local candidate = new_root .. "/" .. rel
	return vim.fn.filereadable(candidate) == 1 and candidate or nil
end

-- Replace `old` buffer with the buffer for `new_path` in every window that shows
-- it (preserving cursor position), then wipe the now-hidden old buffer so it
-- doesn't dangle in the buffer list still pointing at the previous worktree.
local function swap_buffer(old, new_path)
	local newbuf = vim.fn.bufadd(new_path)
	vim.bo[newbuf].buflisted = true
	vim.fn.bufload(newbuf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == old then
			local pos = vim.api.nvim_win_get_cursor(win)
			vim.api.nvim_win_set_buf(win, newbuf)
			pcall(vim.api.nvim_win_set_cursor, win, pos)
		end
	end
	pcall(vim.api.nvim_buf_delete, old, { force = false })
end

-- Re-point every loaded, normal file buffer that has an equivalent in `new_root`.
-- Only `buftype == ""` buffers are touched, so terminals (CodeCompanion's
-- `claude` sessions), help, quickfix, and other scratch buffers are left alone.
-- Modified buffers are skipped to avoid discarding unsaved changes.
local function repoint_buffers(new_root)
	local skipped = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
			local candidate = equivalent_in(vim.api.nvim_buf_get_name(buf), new_root)
			if candidate then
				if vim.bo[buf].modified then
					skipped = skipped + 1
				else
					swap_buffer(buf, candidate)
				end
			end
		end
	end
	if skipped > 0 then
		vim.notify(skipped .. " modified buffer(s) left on the old worktree", vim.log.levels.WARN)
	end
end

-- Switch to a worktree: change the global cwd, then open the equivalent file if
-- one exists, otherwise fall back to a files picker rooted at the worktree.
local function switch(item)
	if not item or item.bare then
		return
	end
	local path = item.worktree
	if vim.fn.isdirectory(path) == 0 then
		vim.notify("Worktree path missing: " .. path, vim.log.levels.ERROR)
		return
	end
	local new_root = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
	vim.cmd("cd " .. vim.fn.fnameescape(path))
	vim.notify("Worktree → " .. label(item) .. "  (" .. path .. ")")

	-- Carry every open file buffer over to the equivalent file in the new tree so
	-- non-focused buffers aren't left pointing at the old worktree. (Running
	-- CodeCompanion `claude` terminals can't follow -- their cwd is fixed at spawn
	-- -- so they're intentionally left behind, see `repoint_buffers`.)
	repoint_buffers(new_root)

	-- Focused-window fallback: if the current window isn't now showing a file in
	-- the new worktree (nothing to re-point to), open the equivalent file if one
	-- exists, otherwise drop into a files picker rooted at the worktree.
	local cur = vim.api.nvim_buf_get_name(0)
	if cur == "" or cur:sub(1, #new_root + 1) ~= new_root .. "/" then
		local equiv = equivalent_in(cur, new_root)
		if equiv then
			vim.cmd("edit " .. vim.fn.fnameescape(equiv))
		else
			Snacks.picker.files({ cwd = path })
		end
	end
end

-- Remove a worktree, prompting to force if git refuses (dirty / locked).
local function remove(item)
	if not item then
		return
	end
	if item.worktree == vim.fn.getcwd() then
		vim.notify("Refusing to remove the current worktree", vim.log.levels.WARN)
		return
	end
	local _, ok = git({ "worktree", "remove", item.worktree })
	if ok then
		vim.notify("Removed worktree " .. label(item))
		return true
	end
	local choice = vim.fn.confirm("Could not remove " .. label(item) .. ". Force?", "&Yes\n&No", 2)
	if choice == 1 then
		local _, forced = git({ "worktree", "remove", "--force", item.worktree })
		vim.notify(forced and ("Force-removed " .. label(item)) or ("Failed to remove " .. label(item)),
			forced and vim.log.levels.INFO or vim.log.levels.ERROR)
		return forced
	end
	return false
end

-- Warn if main's worktree has uncommitted changes. Branching off the `main`
-- ref always uses its last committed snapshot, so those changes are never
-- carried over -- we just make that explicit to the user.
local function warn_if_main_dirty()
	for _, item in ipairs(list_worktrees()) do
		if item.branch == "main" then
			local status = git({ "-C", item.worktree, "status", "--porcelain" })
			if #status > 0 then
				vim.notify("main has uncommitted changes; new branch is based on the last committed main",
					vim.log.levels.WARN)
			end
			return
		end
	end
end

-- Absolute path of the main working tree (parent of the shared `.git` common
-- dir), regardless of which linked worktree we're currently in.
local function main_root()
	local out, ok = git({ "rev-parse", "--path-format=absolute", "--git-common-dir" })
	if not ok or not out[1] or out[1] == "" then
		return nil
	end
	return vim.fn.fnamemodify(out[1], ":h")
end

-- Create a new worktree from a single typed name: the path is
-- `<main-root>/.worktrees/<name>` and the branch is `<name>`. New branches are
-- always created off the committed tip of `main` via `git branch` first, so
-- `git worktree add` never needs `-b`.
local function add(default, refresh)
	Snacks.input.input({ prompt = "New Worktree Name", default = default or "" }, function(name)
		if not name or name:match("^%s*$") then
			return
		end

		local root = main_root()
		if not root then
			vim.notify("Could not determine the main repo root", vim.log.levels.ERROR)
			return
		end
		local branch = name
		local path = root .. "/.worktrees/" .. name
		vim.fn.mkdir(root .. "/.worktrees", "p")

		-- create the branch off the committed tip of main if it doesn't exist yet
		local _, exists = git({ "rev-parse", "--verify", "--quiet", "refs/heads/" .. branch })
		if not exists then
			local _, has_main = git({ "rev-parse", "--verify", "--quiet", "refs/heads/main" })
			if not has_main then
				vim.notify("No local `main` branch to base off of", vim.log.levels.ERROR)
				return
			end
			warn_if_main_dirty()
			local _, made = git({ "branch", branch, "refs/heads/main" })
			if not made then
				vim.notify("Failed to create branch " .. branch .. " off main", vim.log.levels.ERROR)
				return
			end
		end

		local _, ok = git({ "worktree", "add", path, branch })
		if not ok then
			vim.notify("Failed to create worktree at " .. path, vim.log.levels.ERROR)
			return
		end
		vim.notify("Created worktree at " .. path)
		if refresh then
			refresh()
		end
		-- Change the global cwd into the freshly created worktree so a REPL
		-- started afterwards (e.g. Conjure's auto-repl `clj -M:repl/conjure`)
		-- launches from here and drops its `.nrepl-port` next to the code --
		-- mirrors `switch` so create-then-connect works the same as swapping.
		local abspath = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
		if vim.fn.isdirectory(abspath) == 1 then
			vim.cmd("cd " .. vim.fn.fnameescape(abspath))
			vim.notify("Worktree → " .. branch .. "  (" .. abspath .. ")")
		end
	end)
end

function M.pick()
	Snacks.picker({
		source = "worktrees",
		preview = "none",
		finder = function()
			return vim.tbl_map(function(item)
				item.text = label(item) .. " " .. item.worktree
				item.file = item.worktree
				return item
			end, list_worktrees())
		end,
		format = function(item)
			local ret = {}
			ret[#ret + 1] = { ("%-30s"):format(label(item)), "SnacksPickerGitBranch" }
			ret[#ret + 1] = { " " }
			ret[#ret + 1] = { vim.fn.fnamemodify(item.worktree, ":~"), "SnacksPickerDir" }
			return ret
		end,
		confirm = function(picker, item)
			picker:close()
			switch(item)
		end,
		actions = {
			worktree_del = function(picker, item)
				if remove(item) then
					picker:find() -- refresh the list in place
				end
			end,
			worktree_add = function(picker)
				add(picker.input:get(), function()
					picker.input:set("", "")
					picker:find()
				end)
			end,
		},
		win = {
			input = {
				keys = {
					["<c-d>"] = { "worktree_del", mode = { "n", "i" } },
					["<c-n>"] = { "worktree_add", mode = { "n", "i" } },
				},
			},
		},
	})
end

return M
