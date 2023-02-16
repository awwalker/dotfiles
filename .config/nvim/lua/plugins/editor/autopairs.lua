local M = {
	"windwp/nvim-autopairs",
	event = "VeryLazy",
	config = function()
		local autopairs = require("nvim-autopairs")
		local cond = require("nvim-autopairs.conds")
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		autopairs.setup({ enable_check_bracket_line = false })
		-- remove add single quote on filetype scheme or lisp
		autopairs.get_rule("'")[1].not_filetypes = { "scheme", "lisp", "clojure" }
		autopairs.get_rule("'")[1]:with_pair(cond.not_after_text("["))
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
	end,
}

return M
