-- Convert a picker's selected items (or all, if none selected) into quickfix
-- entries. Mirrors snacks' own setqflist() item -> qf conversion.
local function picker_to_qf(picker)
	local sel = picker:selected()
	local items = #sel > 0 and sel or picker:items()
	local qf = {}
	for _, item in ipairs(items) do
		qf[#qf + 1] = {
			filename = Snacks.picker.util.path(item),
			bufnr = item.buf,
			lnum = item.pos and item.pos[1] or 1,
			col = item.pos and item.pos[2] + 1 or 1,
			end_lnum = item.end_pos and item.end_pos[1] or nil,
			end_col = item.end_pos and item.end_pos[2] + 1 or nil,
			text = item.line or item.comment or item.label or item.name or item.detail or item.text,
			pattern = item.search,
			type = ({ "E", "W", "I", "N" })[item.severity],
			valid = true,
		}
	end
	return qf
end

local M = {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		---@type snacks.Config
		opts = {
			picker = {
				layout = {
					preset = "telescope",
				},
				actions = {
					-- Override the built-in `qflist` action (bound to <c-q>) so that
					-- when a quickfix list already has entries, results are *appended*
					-- to it instead of replacing it. The first <c-q> creates the list;
					-- subsequent <c-q> from other searches add to that same list.
					qflist = function(picker)
						picker:close()
						local qf = picker_to_qf(picker)
						local exists = vim.fn.getqflist({ size = 0 }).size > 0
						vim.fn.setqflist(qf, exists and "a" or " ")
						vim.cmd("botright copen")
					end,
					-- Always replace the quickfix list with a fresh one (bound to
					-- <C-S-q>) -- the original snacks `qflist` behavior.
					qflist_replace = function(picker)
						picker:close()
						vim.fn.setqflist(picker_to_qf(picker), " ")
						vim.cmd("botright copen")
					end,
				},
				win = {
					input = {
						keys = {
							["<C-S-q>"] = { "qflist_replace", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<C-S-q>"] = "qflist_replace",
						},
					},
				},
			},
		},
		keys = {
			{
				"<c-f>",
				function()
					Snacks.picker.files()
				end,
				desc = "Files",
			},
			{
				"<c-g>",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			{
				"<leader>f",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>t",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer",
			},
			{
				"<c-b>",
				function()
					Snacks.picker.buffers({
						win = {
							input = {
								keys = {
									["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Buffers",
			},
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches({
						win = {
							input = {
								keys = {
									["<c-n>"] = { "git_branch_add", mode = { "n", "i" } },
									["<c-d>"] = { "git_branch_del", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Git branches",
			},
			{
				"<leader>gw",
				function()
					require("utils.worktree").pick()
				end,
				desc = "Git worktrees",
			},
			{
				"<leader>r",
				function()
					Snacks.picker.lsp_references()
				end,
				desc = "LSP references",
			},
			{
				"<A-m>",
				function()
					Snacks.picker.marks({
						win = {
							input = {
								keys = {
									["<c-d>"] = { "mark_delete", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Marks",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
		},
	},
}

return M
