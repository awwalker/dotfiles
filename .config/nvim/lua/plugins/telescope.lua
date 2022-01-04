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
