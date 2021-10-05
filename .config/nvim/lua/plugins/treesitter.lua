-- =============================
--          TREESITTER
-- =============================
require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	rainbow = {
		enable = true,
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	pairs = {
		enable = true,
		highlight_self = false,
		goto_right_end = false,
		fallback_cmd_normal = "normal! %",
	},
	autopairs = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["fo"] = "@function.outer",
				["fi"] = "@function.inner",
				["co"] = "@class.outer",
				["ci"] = "@class.inner",
        ["bi"] = "@block.inner",
        ["bo"] = "@block.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})
