local M = {
	"windwp/nvim-autopairs",
	event = "VeryLazy",
	config = function()
		local autopairs = require("nvim-autopairs")
		local cond = require("nvim-autopairs.conds")

		autopairs.setup({
			enable_check_bracket_line = false,
			disable_filetype = { "TelescopePrompt" },
		})

		autopairs.get_rule("'")[1].not_filetypes = { "scheme", "lisp", "clojure" }
		autopairs.get_rule("'")[1]:with_pair(cond.not_after_text("["))
	end,
}

return M
