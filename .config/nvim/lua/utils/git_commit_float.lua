local M = {}

-- Resolve the git repo root that owns the given path (or the cwd).
local function repo_root(path)
	local dir = vim.fn.fnamemodify(path ~= "" and path or vim.fn.getcwd(), ":p:h")
	local out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
	if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
		return nil
	end
	return out[1]
end

-- Open a floating buffer to write a commit message for the currently staged
-- changes, then run `git commit` on confirm. Mirrors codecompanion's floating
-- prompt: centered float, starts in insert, <C-s> to confirm, q / <C-c> cancel.
function M.open()
	local root = repo_root(vim.api.nvim_buf_get_name(0))
	if not root then
		vim.notify("Not inside a git repository", vim.log.levels.ERROR)
		return
	end

	-- `git diff --cached --quiet` exits 0 when nothing is staged.
	vim.fn.system({ "git", "-C", root, "diff", "--cached", "--quiet" })
	if vim.v.shell_error == 0 then
		vim.notify("Nothing staged to commit", vim.log.levels.WARN)
		return
	end

	-- Prefill with the staged file list as comments (stripped by --cleanup=strip).
	local branch = vim.fn.systemlist({ "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" })[1] or "?"
	local staged = vim.fn.systemlist({ "git", "-C", root, "diff", "--cached", "--name-status" })
	local lines = { "", "", "# On branch " .. branch, "# Staged changes:" }
	for _, l in ipairs(staged) do
		lines[#lines + 1] = "#   " .. l
	end
	lines[#lines + 1] = "#"
	lines[#lines + 1] = "# '#' lines are ignored. <C-s> to commit, q / <C-c> to cancel."

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "gitcommit"
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(80, math.floor(vim.o.columns * 0.8))
	local height = math.min(20, math.floor(vim.o.lines * 0.6))
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2 - 1),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " git commit ",
		title_pos = "center",
	})
	vim.wo[win].wrap = true
	vim.wo[win].spell = true

	local closed = false
	local function close()
		if closed then
			return
		end
		closed = true
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	local function commit()
		local tmp = vim.fn.tempname()
		vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), tmp)
		local out = vim.fn.systemlist({ "git", "-C", root, "commit", "--cleanup=strip", "-F", tmp })
		vim.fn.delete(tmp)
		if vim.v.shell_error ~= 0 then
			-- Keep the float open so the typed message isn't lost.
			vim.notify("git commit failed:\n" .. table.concat(out, "\n"), vim.log.levels.ERROR)
			return
		end
		close()
		vim.notify(table.concat(out, "\n"))
		pcall(function()
			require("gitsigns").refresh()
		end)
	end

	local opts = { buffer = buf, nowait = true, silent = true }
	vim.keymap.set("n", "<C-s>", commit, opts)
	vim.keymap.set("i", "<C-s>", function()
		vim.cmd("stopinsert")
		commit()
	end, opts)
	vim.keymap.set("n", "q", close, opts)
	vim.keymap.set({ "n", "i" }, "<C-c>", function()
		vim.cmd("stopinsert")
		close()
	end, opts)

	vim.api.nvim_win_set_cursor(win, { 1, 0 })
	vim.cmd("startinsert")
end

return M
