local telescope = require("telescope")
local actions = require("telescope.actions")
local builtins = require("telescope.builtin")

-- Credit https://github.com/nvim-telescope/telescope.nvim/issues/223#issuecomment-810091610
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local noremap_silent = { noremap = true, silent = true }

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
		file_ignore_patterns = { "node_modules", ".git" },
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
		live_grep_raw = {},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_raw")

-- local Path = require "plenary.path"
-- local action_set = require "telescope.actions.set"
-- local action_state = require "telescope.actions.state"
-- local actions = require "telescope.actions"
-- local conf = require("telescope.config").values
-- local finders = require "telescope.finders"
-- local make_entry = require "telescope.make_entry"
-- local os_sep = Path.path.sep
-- local pickers = require "telescope.pickers"
-- local scan = require "plenary.scandir"
--
-- local my_pickers = {}
--
-- my_pickers.live_grep_in_folder = function(opts)
--   opts = opts or {}
--   local data = {}
--   scan.scan_dir(vim.loop.cwd(), {
--     hidden = opts.hidden,
--     only_dirs = true,
--     respect_gitignore = opts.respect_gitignore,
--     on_insert = function(entry)
--       table.insert(data, entry .. os_sep)
--     end,
--   })
--   table.insert(data, 1, "." .. os_sep)
--
--   pickers.new(opts, {
--     prompt_title = "Folders for Live Grep",
--     finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file(opts) },
--     previewer = conf.file_previewer(opts),
--     sorter = conf.file_sorter(opts),
--     attach_mappings = function(prompt_bufnr)
--       action_set.select:replace(function()
--         local current_picker = action_state.get_current_picker(prompt_bufnr)
--         local dirs = {}
--         local selections = current_picker:get_multi_selection()
--         if vim.tbl_isempty(selections) then
--           table.insert(dirs, action_state.get_selected_entry().value)
--         else
--           for _, selection in ipairs(selections) do
--             table.insert(dirs, selection.value)
--           end
--         end
--         actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
--         require("telescope.builtin").live_grep { search_dirs = dirs }
--       end)
--       return true
--     end,
--   }):find()
-- end
--
-- return my_pickers
