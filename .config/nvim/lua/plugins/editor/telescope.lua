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

local noremap_silent = { noremap = true, silent = true }

local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"debugloop/telescope-undo.nvim",
	},
	event = "VeryLazy",
	cmd = "Telescope",
	keys = {
		{ "<c-f>", "<cmd> Telescope find_files<CR>", mode = "n", noremap_silent },
		{ "<leader>f", "<cmd> Telescope live_grep_args<CR>", mode = "n", noremap_silent },
		{ "<c-b>", "<cmd> Telescope buffers<CR>", mode = "n", noremap_silent },
		{ "<c-g>", "<cmd> Telescope grep_string<CR>", mode = "n", noremap_silent },
		{ "<leader>gb", "<cmd> Telescope git_branches<CR>", mode = "n", noremap_silent },
		{ "<leader>r", "<cmd> Telescope lsp_references<CR>", mode = "n", noremap_silent },
		{ "<A-m>", "<cmd> Telescope marks<CR>", mode = "n", noremap_silent },
		{ "<c-u>", "<cmd> Telescope undo<CR>", mode = "n", noremap_silent },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local themes = require("telescope.themes")
		local lga_actions = require("telescope-live-grep-args.actions")
		local undo_actions = require("telescope-undo.actions")

		-- Credit https://github.com/nvim-telescope/telescope.nvim/issues/223#issuecomment-810091610
		local previewers = require("telescope.previewers")
		local Job = require("plenary.job")

		local new_maker = function(filepath, bufnr, opts)
			filepath = vim.fn.expand(filepath)
			Job:new({
				command = "file",
				args = { "--mime-type", "-b", filepath },
				on_exit = function(j)
					local result = vim.split(j:result()[1], "/")
					local mime_type = result[1]
					local is_json = result[2] == "json"
					if mime_type == "text" or is_json then
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					else
						-- maybe we want to write something to the buffer here
						vim.schedule(function()
							vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
						end)
					end
				end,
			}):sync()
		end

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
						["<C-s>"] = actions.select_horizontal,
						["<C-d>"] = actions.delete_buffer,
						["<C-f>"] = actions.to_fuzzy_refine,
					},
					n = {
						["<C-s>"] = actions.select_horizontal,
						["<C-d>"] = actions.delete_buffer,
						["<C-f>"] = actions.to_fuzzy_refine,
					},
				},
				file_ignore_patterns = { "node_modules" },
				set_env = { ["COLORTERM"] = "truecolor" },
				buffer_previewer_maker = new_maker,
				previewer = true,
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
							["<C-'>i"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							["<C-'>t"] = lga_actions.quote_prompt({ postfix = " -t" }),
							["<C-f>"] = actions.to_fuzzy_refine,
						},
					},
				},
				["ui-select"] = {
					themes.get_cursor({}),
				},
				undo = {
					use_delta = true,
					mappings = {
						i = {
							["<C-space>"] = undo_actions.yank_additions,
							["<CR>"] = undo_actions.restore,
							["<A-CR>"] = undo_actions.yank_deletions,
						},
					},
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
						n = { ["<C-d>"] = actions.delete_buffer },
						i = { ["<C-f>"] = actions.to_fuzzy_refine },
					},
				},
				find_files = {
					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
						"-I",
						"-E",
						".git",
						"-E",
						"*.pyc",
						"-E",
						"node_modules",
					},
					mappings = {
						i = { ["<C-f>"] = actions.to_fuzzy_refine },
					},
				},
				git_branches = {
					mappings = {
						i = {
							["<CR>"] = actions.git_switch_branch,
							["<C-r>"] = actions.git_rebase_branch,
							["<C-d>"] = actions.git_delete_branch,
						},
					},
				},
				lsp_code_actions = {
					theme = "cursor",
					previewer = false,
				},
				live_grep = {
					only_sort_text = true,
					mappings = {
						i = { ["<C-f>"] = actions.to_fuzzy_refine },
					},
				},
				grep_string = {
					only_sort_text = true,
					mappings = {
						i = { ["<C-f>"] = actions.to_fuzzy_refine },
					},
				},
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("ui-select")
		telescope.load_extension("undo")
	end,
}
return M
