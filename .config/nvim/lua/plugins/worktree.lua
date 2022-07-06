-- =============================
--            WORKTREE
-- =============================
local worktree = require("git-worktree")
worktree.on_tree_change(function(op, metadata)
	if op == worktree.Operations.Create then
		local makefile = io.open("Makefile")
		if makefile == nil then
			return
		end
		vim.cmd([[ Make! db_rebuild ]])
	end
end)
worktree.setup()
