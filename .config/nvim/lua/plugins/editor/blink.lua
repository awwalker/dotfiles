local M = {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"onsails/lspkind-nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			appearance = {
				use_nvim_cmp_as_default = true,
			},
			keymap = {
				["<CR>"] = { "accept", "fallback" },
				["<c-k"] = { "scroll_documentation_up" },
				["<c-j"] = { "scroll_documentation_down" },
			},
			completion = {
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				menu = {
					auto_show = false,
					draw = {
						treesitter = { "lsp" },
						-- 	columns = {
						-- 		{ "label", "label_description", gap = 1 },
						-- 		{ "kind_icon", "kind" },
						-- 	},
					},
				},
				ghost_text = {
					enabled = false, -- need separate font color for this
					show_with_menu = true,
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "single",
					show_documentation = false,
				},
			},
			sources = {
				default = { "lsp", "buffer", "path" },
				per_filetype = {
					sql = { "dadbod", "buffer" },
				},
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					conjure = { name = "conjure", module = "blink.compat.source" },
					nvim_lua = { name = "nvim_lua", module = "blink.compat.source" },
					buffer = {
						opts = {
							-- or (recommended) filter to only "normal" buffers
							get_bufnrs = function()
								return vim.tbl_filter(function(bufnr)
									return vim.bo[bufnr].buftype == ""
								end, vim.api.nvim_list_bufs())
							end,
						},
					},
				},
			},
			cmdline = {
				enabled = true,
				sources = function()
					local type = vim.fn.getcmdtype()

					if type == "/" or type == "?" then
						return { "buffer" }
					end
					if type == ":" or type == "@" then
						return { "cmdline", "path", "buffer" }
					end
					return {}
				end,
				completion = {
					menu = { auto_show = false },
				},
				keymap = {
					-- optionally, inherit the mappings from the top level `keymap`
					-- instead of using the neovim defaults
					-- preset = 'inherit',

					["<Tab>"] = {
						function(cmp)
							if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
								return cmp.accept()
							end
						end,
						"show_and_insert",
						"select_next",
					},
					["<S-Tab>"] = { "show_and_insert", "select_prev" },

					["<C-space>"] = { "show", "fallback" },

					["<Down>"] = { "select_next", "fallback" },
					["<Up>"] = { "select_prev", "fallback" },
					["<Right>"] = { "select_next", "fallback" },
					["<Left>"] = { "select_prev", "fallback" },

					["<CR>"] = { "select_and_accept", "fallback" },
					["<C-e>"] = { "hide" },
				},
			},
		},
	},
}

return M
