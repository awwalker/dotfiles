-- =============================
--    TERMINAL / TAB TITLE
-- =============================
-- Produces a Ghostty tab label like:  repo:branch — file
-- so tabs are identifiable and the native tab overview (cmd+shift+\)
-- can be filtered by typing part of the repo/branch name.

local M = {}

-- Cache branch lookups per git root so we don't re-read HEAD on every redraw.
local branch_cache = {}

-- Read the branch for a given repo/worktree root by parsing .git directly
-- (no shell spawn). Handles worktrees, whose `.git` is a file pointing at the
-- real gitdir via `gitdir: <path>`.
local function read_branch(root)
	if not root then
		return ""
	end
	if branch_cache[root] ~= nil then
		return branch_cache[root]
	end

	local gitpath = root .. "/.git"
	local head_file
	local stat = vim.uv.fs_stat(gitpath)
	if stat and stat.type == "directory" then
		head_file = gitpath .. "/HEAD"
	elseif stat and stat.type == "file" then
		-- Worktree: `.git` is a file containing `gitdir: /path/to/gitdir`
		local lines = vim.fn.readfile(gitpath)
		local gitdir = lines[1] and lines[1]:match("^gitdir:%s*(.+)$")
		if gitdir then
			-- gitdir may be relative to root
			if gitdir:sub(1, 1) ~= "/" then
				gitdir = root .. "/" .. gitdir
			end
			head_file = gitdir .. "/HEAD"
		end
	end

	local branch = ""
	if head_file and vim.uv.fs_stat(head_file) then
		local head = vim.fn.readfile(head_file)[1] or ""
		-- `ref: refs/heads/<branch>` on a branch, or a bare SHA when detached.
		branch = head:match("^ref:%s*refs/heads/(.+)$") or head:sub(1, 7)
	end

	branch_cache[root] = branch
	return branch
end

function M.invalidate()
	branch_cache = {}
end

function M.tab()
	local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
	local repo = vim.fn.fnamemodify(root, ":t")
	local branch = read_branch(root)
	local file = vim.fn.expand("%:t")
	if file == "" then
		file = "[No Name]"
	end

	local label = repo
	if branch ~= "" then
		label = label .. ":" .. branch
	end
	return label .. " — " .. file
end

-- Bust the branch cache when the working dir changes (e.g. :cd, worktree
-- switch) so a checkout in another process is picked up on next focus.
vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained" }, {
	group = vim.api.nvim_create_augroup("TabTitleCache", { clear = true }),
	callback = M.invalidate,
})

return M
