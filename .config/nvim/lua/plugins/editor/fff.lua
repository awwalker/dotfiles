local M = {
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			-- this will download prebuild binary or try to use existing rustup toolchain to build from source
			-- (if you are using lazy you can use gb for rebuilding a plugin if needed)
			require("fff.download").download_or_build_binary()
		end,
		-- if you are using nixos
		-- build = "nix run .#release",
		opts = { -- (optional)
			debug = {
				enabled = true, -- we expect your collaboration at least during the beta
				show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
			},
			keymaps = {
				move_up = { "<Up>", "<C-p>", "<C-k>" }, -- Three ways to move up
				close = { "<Esc>", "<C-c>" }, -- Two ways to close
				select = "<CR>", -- Single binding still works
			},
		},
		-- No need to lazy-load with lazy.nvim.
		-- This plugin initializes itself lazily.
		lazy = false,
		keys = {
			{
				"<c-f>", -- try it if you didn't it is a banger keybinding for a picker
				function()
					require("fff").find_files()
				end,
				desc = "FFFind files",
			},
		},
	},
}

return M
