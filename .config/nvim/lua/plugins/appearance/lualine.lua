local M = {
	"nvim-lualine/lualine.nvim",
	lazy = true,
	-- This event must match what is in alpha-nvim.
	event = "BufEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lualine = require("lualine")
    -- Color table for highlights
    -- stylua: ignore
    local colors = {
      bg       = '#202328',
      fg       = '#bbc2cf',
      yellow   = '#ECBE7B',
      cyan     = '#008080',
      darkblue = '#081633',
      green    = '#98be65',
      orange   = '#FF8800',
      violet   = '#a9a1e1',
      magenta  = '#c678dd',
      blue     = '#51afef',
      red      = '#ec5f67',
    }

		-- Git diff stats shown only in the fugitive status window.
		-- Computed asynchronously and cached so statusline redraws never block.
		local git_stats = { text = "", br_ins = 0, br_del = 0, wt_ins = 0, wt_del = 0 }

		local function set_stat_hls()
			vim.api.nvim_set_hl(0, "LualineGitAdd", { fg = colors.green, bg = colors.bg })
			vim.api.nvim_set_hl(0, "LualineGitDel", { fg = colors.red, bg = colors.bg })
			vim.api.nvim_set_hl(0, "LualineGitLbl", { fg = colors.violet, bg = colors.bg, bold = true })
		end
		set_stat_hls()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_stat_hls })

		local function build_stats_text()
			git_stats.text = string.format(
				"%%#LualineGitLbl# %%#LualineGitAdd#+%d %%#LualineGitDel#-%d"
					.. "  %%#LualineGitLbl# %%#LualineGitAdd#+%d %%#LualineGitDel#-%d%%*",
				git_stats.br_ins,
				git_stats.br_del,
				git_stats.wt_ins,
				git_stats.wt_del
			)
			vim.schedule(function()
				vim.cmd("redrawstatus")
			end)
		end

		local function run_git(cargs, cwd, cb)
			vim.system(vim.list_extend({ "git" }, cargs), { cwd = cwd, text = true }, function(res)
				vim.schedule(function()
					cb(res.code == 0 and res.stdout or nil)
				end)
			end)
		end

		local function parse_shortstat(out)
			if not out then
				return 0, 0
			end
			return tonumber(out:match("(%d+) insertion")) or 0, tonumber(out:match("(%d+) deletion")) or 0
		end

		-- Find the base ref to diff the branch against (first that shares history).
		local function find_base(cwd, cb)
			local candidates = { "origin/main", "main", "origin/master", "master" }
			local idx = 0
			local function try()
				idx = idx + 1
				local ref = candidates[idx]
				if not ref then
					cb(nil)
					return
				end
				run_git({ "merge-base", "HEAD", ref }, cwd, function(out)
					if out and out:match("%w") then
						cb(ref)
					else
						try()
					end
				end)
			end
			try()
		end

		local function refresh_git_stats()
			local ok, wt = pcall(vim.fn.FugitiveWorkTree)
			local cwd = (ok and wt ~= "") and wt or vim.fn.getcwd()

			-- Uncommitted (staged + unstaged) changes vs the last commit.
			run_git({ "diff", "HEAD", "--shortstat" }, cwd, function(out)
				git_stats.wt_ins, git_stats.wt_del = parse_shortstat(out)
				build_stats_text()
			end)

			-- Whole branch vs its merge-base with the base branch.
			find_base(cwd, function(base)
				if not base then
					git_stats.br_ins, git_stats.br_del = 0, 0
					build_stats_text()
					return
				end
				run_git({ "diff", base .. "...HEAD", "--shortstat" }, cwd, function(out)
					git_stats.br_ins, git_stats.br_del = parse_shortstat(out)
					build_stats_text()
				end)
			end)
		end

		local stats_group = vim.api.nvim_create_augroup("LualineFugitiveStats", { clear = true })
		vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
			group = stats_group,
			pattern = "fugitive",
			callback = refresh_git_stats,
		})
		vim.api.nvim_create_autocmd("User", {
			group = stats_group,
			pattern = "FugitiveChanged",
			callback = refresh_git_stats,
		})

		-- Dadbod query spinner: animates while an async DB query is in flight.
		-- vim-dadbod (master) fires `User <output>/DBExecutePre` before and
		-- `User <output>/DBExecutePost` after each async job. We count in-flight
		-- queries (several can run at once) and drive a uv timer to animate,
		-- since the statusline only redraws when something tells it to.
		local dadbod = { active = 0, frame = 1, timer = nil }
		local dadbod_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

		local function dadbod_stop_timer()
			if dadbod.timer then
				dadbod.timer:stop()
				dadbod.timer:close()
				dadbod.timer = nil
			end
		end

		local function dadbod_start_timer()
			if dadbod.timer then
				return
			end
			dadbod.timer = vim.uv.new_timer()
			dadbod.timer:start(
				0,
				100,
				vim.schedule_wrap(function()
					dadbod.frame = dadbod.frame % #dadbod_frames + 1
					vim.cmd("redrawstatus")
				end)
			)
		end

		local dadbod_group = vim.api.nvim_create_augroup("LualineDadbodSpinner", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = dadbod_group,
			pattern = "*DBExecutePre",
			callback = function()
				dadbod.active = dadbod.active + 1
				dadbod_start_timer()
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = dadbod_group,
			pattern = "*DBExecutePost",
			callback = function()
				dadbod.active = math.max(0, dadbod.active - 1)
				if dadbod.active == 0 then
					dadbod_stop_timer()
					vim.schedule(function()
						vim.cmd("redrawstatus")
					end)
				end
			end,
		})

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local evil_config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				globalstatus = true,
				disabled_filetypes = {
					"alpha",
					"lazy",
				},
				theme = {
					-- We are going to use lualine_c an lualine_x as left and
					-- right section. Both are highlighted by c theme .  So we
					-- are just setting default looks o statusline
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(evil_config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x ot right section
		local function ins_right(component)
			table.insert(evil_config.sections.lualine_x, component)
		end

		ins_left({
			function()
				return "▊"
			end,
			color = { fg = colors.blue }, -- Sets highlighting of component
			padding = { left = 0, right = 1 }, -- We don't need space before this
		})

		ins_left({
			-- mode component
			function()
				return ""
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[""] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[""] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({
			-- filesize component
			"filesize",
			cond = conditions.buffer_not_empty,
		})

		ins_left({
			"filename",
			path = 1,
			cond = conditions.buffer_not_empty,
			color = { fg = colors.magenta, gui = "bold" },
			fmt = function(s, ctx)
				return string.format("%-50s", s)
			end,
		})

		ins_left({ "location" })

		ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				color_error = { fg = colors.red },
				color_warn = { fg = colors.yellow },
				color_info = { fg = colors.cyan },
			},
		})

		-- Fugitive git stats: branch vs base | uncommitted working tree.
		ins_left({
			function()
				return git_stats.text
			end,
			cond = function()
				return vim.bo.filetype == "fugitive"
			end,
		})

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left({
			function()
				return "%="
			end,
		})

		ins_left({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local clients = vim.lsp.get_clients({ bufnr = 0 })

				return #clients > 0
						and table.concat(
							vim.tbl_map(function(client)
								return client.name
							end, clients),
							","
						)
					or msg
			end,
			icon = " LSP:",
			color = { fg = "#ffffff", gui = "bold" },
		})
		-- Add components to right sections
		-- Dadbod query spinner (only visible while a query is running).
		ins_right({
			function()
				return dadbod_frames[dadbod.frame] .. "  Running query"
			end,
			cond = function()
				return dadbod.active > 0
			end,
			color = { fg = colors.orange, gui = "bold" },
		})

		ins_right(require("codecompanion._extensions.spinner.styles.lualine").get_lualine_component())

		-- CodeCompanion token count
		ins_right({
			function()
				local bufnr = vim.api.nvim_get_current_buf()
				if vim.bo[bufnr].filetype ~= "codecompanion" then
					return ""
				end

				if not _G.codecompanion_chat_metadata then
					return ""
				end

				local metadata = _G.codecompanion_chat_metadata[bufnr]
				if not metadata then
					return ""
				end

				if metadata.tokens and metadata.tokens > 0 then
					return "  " .. metadata.tokens
				end

				return ""
			end,
			color = { fg = colors.cyan, gui = "bold" },
		})

		ins_right({
			"o:encoding", -- option component same as &encoding in viml
			fmt = string.upper, -- I'm not sure why it's upper case either ;)
			cond = conditions.hide_in_width,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			"fileformat",
			fmt = string.upper,
			icons_enabled = true,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			"branch",
			icon = "",
			color = { fg = colors.violet, gui = "bold" },
		})

		ins_right({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = " ", modified = " ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { fg = colors.blue },
			padding = { left = 1 },
		})
		lualine.setup(evil_config)
	end,
}

return M
