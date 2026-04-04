local M = {
	url = "https://codeberg.org/andyg/leap.nvim",
	event = "BufReadPre",
	config = function()
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
		vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

		--vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
		--vim.api.nvim_set_hl(0, "LeapMatch", {
		--	fg = "white", -- for light themes, set to 'black' or similar
		--	bold = true,
		--	nocombine = true,
		--})
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("LeapColorTweaks", {}),
			callback = function()
				-- Forces using the defaults: sets `IncSearch` for labels,
				-- `Search` for matches, and updates the look of concealed labels.
				require("leap").init_hl(true)
			end,
		})
		-- Highly recommended: define a preview filter to reduce visual noise
		-- and the blinking effect after the first keypress.
		-- For example, define word boundaries as the common case, that is, skip
		-- preview for matches starting with whitespace or an alphabetic
		-- mid-word character: foobar[baaz] = quux
		--                     *    ***  ** * *  *
		require("leap").opts.preview = function(ch0, ch1, ch2)
			return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
		end
		-- Enable the traversal keys to repeat the previous search without
		-- explicitly invoking Leap (`<cr><cr>...` instead of `s<cr><cr>...`):
		do
			local clever = require("leap.user").with_traversal_keys
			-- For relative directions, set the `backward` flags according to:
			-- local prev_backward = require('leap').state['repeat'].backward
			vim.keymap.set({ "n", "x", "o" }, "<cr>", function()
				require("leap").leap({
					["repeat"] = true,
					opts = clever("<cr>", "<bs>"),
				})
			end)
			vim.keymap.set({ "n", "x", "o" }, "<bs>", function()
				require("leap").leap({
					["repeat"] = true,
					opts = clever("<bs>", "<cr>"),
					backward = true,
				})
			end)
		end
		do
			local function ft(key_specific_args)
				require("leap").leap(vim.tbl_deep_extend("keep", key_specific_args, {
					inputlen = 1,
					inclusive = true,
					opts = {
						-- Force autojump.
						labels = "",
						-- Match the modes where you don't need labels (`:h mode()`).
						safe_labels = vim.fn.mode(1):match("o") and "" or nil,
					},
				}))
			end

			-- A helper function making it easier to set "clever-f" behavior
			-- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
			local clever = require("leap.user").with_traversal_keys
			local clever_f, clever_t = clever("f", "F"), clever("t", "T")

			vim.keymap.set({ "n", "x", "o" }, "f", function()
				ft({ opts = clever_f })
			end)
			vim.keymap.set({ "n", "x", "o" }, "F", function()
				ft({ backward = true, opts = clever_f })
			end)
			vim.keymap.set({ "n", "x", "o" }, "t", function()
				ft({ offset = -1, opts = clever_t })
			end)
			vim.keymap.set({ "n", "x", "o" }, "T", function()
				ft({ backward = true, offset = 1, opts = clever_t })
			end)
		end
		vim.api.nvim_create_autocmd("CmdlineLeave", {
			group = vim.api.nvim_create_augroup("LeapOnSearch", {}),
			callback = function()
				local ev = vim.v.event
				local is_search_cmd = (ev.cmdtype == "/") or (ev.cmdtype == "?")
				local cnt = vim.fn.searchcount().total
				if is_search_cmd and not ev.abort and (cnt > 1) then
					-- Allow CmdLineLeave-related chores to be completed before
					-- invoking Leap.
					vim.schedule(function()
						-- We want "safe" labels, but no autojump (as the search
						-- command already does that), so just use `safe_labels`
						-- as `labels`, with n/N removed.
						local labels = require("leap").opts.safe_labels:gsub("[nN]", "")
						-- For `pattern` search, we never need to adjust conceallevel
						-- (no user input). We cannot merge `nil` from a table, but
						-- using the option's current value has the same effect.
						local vim_opts = { ["wo.conceallevel"] = vim.wo.conceallevel }
						require("leap").leap({
							pattern = vim.fn.getreg("/"), -- last search pattern
							windows = { vim.fn.win_getid() },
							opts = { safe_labels = "", labels = labels, vim_opts = vim_opts },
						})
					end)
				end
			end,
		})
		do
			local function leap_search(key, rev_key, is_reverse)
				local cmdline_mode = vim.fn.mode(true):match("^c")
				if cmdline_mode then
					-- Finish the search command.
					vim.api.nvim_feedkeys(vim.keycode("<enter>"), "t", false)
				end
				if vim.fn.searchcount().total < 1 then
					return
				end
				-- Activate again if `:nohlsearch` has been used (Normal/Visual mode).
				vim.go.hlsearch = vim.go.hlsearch
				-- Allow the search command to complete its chores before
				-- invoking Leap (Command-line mode).
				vim.schedule(function()
					require("leap").leap({
						pattern = vim.fn.getreg("/"),
						-- If you always want to go forward/backward with the given key,
						-- regardless of the previous search direction, just set this to
						-- `is_reverse`.
						backward = (is_reverse and vim.v.searchforward == 1) or (not is_reverse and vim.v.searchforward == 0),
						opts = require("leap.user").with_traversal_keys(key, rev_key, {
							-- Autojumping to the second match would be confusing without
							-- 'incsearch'.
							safe_labels = (cmdline_mode and not vim.o.incsearch) and ""
								-- Keep n/N usable in any case.
								or require("leap").opts.safe_labels:gsub("[nN]", ""),
						}),
					})
					-- You might want to switch off the highlights after leaping.
					-- vim.cmd('nohlsearch')
				end)
			end

			vim.keymap.set({ "n", "x", "o", "c" }, "<c-s>", function()
				leap_search("<c-s>", "<c-q>", false)
			end, { desc = "Leap to search matches" })

			vim.keymap.set({ "n", "x", "o", "c" }, "<c-q>", function()
				leap_search("<c-q>", "<c-s>", true)
			end, { desc = "Leap to search matches (reverse)" })
		end
	end,
}

return M
