local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local lga_actions = require("telescope-live-grep-args.actions")

-- Credit https://github.com/nvim-telescope/telescope.nvim/issues/223#issuecomment-810091610
local previewers = require("telescope.previewers")
local Job = require("plenary.job")

local M = {}

local new_maker = function(filepath, bufnr, opts)
	filepath = vim.fn.expand(filepath)
	Job
		:new({
			command = "file",
			args = { "--mime-type", "-b", filepath },
			on_exit = function(j)
				local mime_type = vim.split(j:result()[1], "/")[1]
				if mime_type == "text" then
					previewers.buffer_previewer_maker(filepath, bufnr, opts)
				else
					-- maybe we want to write something to the buffer here
					vim.schedule(function()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
					end)
				end
			end,
		})
		:sync()
end

-- Custom window-sizes

local width_for_nopreview = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.5)
	elseif cols > 110 then
		return math.floor(cols * 0.6)
	else
		return math.floor(cols * 0.75)
	end
end

local height_dropdown_nopreview = function(_, _, rows)
	return math.floor(rows * 0.7)
end

-- Credit https://github.com/nvim-telescope/telescope.nvim
telescope.setup({
	defaults = {
		prompt_prefix = " ",
		layout_config = {
			horizontal = { mirror = false, preview_width = 0.5 },
			vertical = { mirror = false },
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<c-s>"] = actions.select_horizontal,
				["<c-d>"] = actions.delete_buffer,
			},
			n = {
				["<c-s>"] = actions.select_horizontal,
				["<c-d>"] = actions.delete_buffer,
			},
		},
		file_ignore_patterns = { "node_modules" },
		set_env = { ["COLORTERM"] = "truecolor" },
		buffer_previewer_maker = new_maker,
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "ignore_case", -- or "ignore_case" or "respect_case" or "smart_case"
		},
		live_grep_args = {
			auto_quoting = true, -- enable/disable auto-quoting
			mappings = {
				i = {
					["<C-'>"] = lga_actions.quote_prompt(),
					["<C-'>g"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					["<C-'>t"] = lga_actions.quote_prompt({ postfix = " -t" }),
				},
			},
		},
		["ui-select"] = {
			themes.get_cursor({}),
		},
	},
	pickers = {
		buffers = {
			previewer = false,
			sort_lastused = true,
			sort_mru = true,
			show_all_buffers = true,
			layout_config = {
				width = width_for_nopreview,
				height = height_dropdown_nopreview,
			},
			mappings = {
				n = {
					["<c-d>"] = actions.delete_buffer,
				},
			},
		},
		find_files = {
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
		},
		lsp_code_actions = {
			theme = "cursor",
			previewer = false,
			layout_config = {
				width = width_for_nopreview,
				height = height_dropdown_nopreview,
			},
		},
		live_grep = {
			only_sort_text = true,
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("git_worktree")
telescope.load_extension("ui-select")

return M
