local M = {
	"ggandor/leap.nvim",
	event = "BufReadPre",
	config = function()
		local leap = require("leap")
		leap.add_default_mappings()
		vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
		vim.api.nvim_set_hl(0, "LeapMatch", {
			fg = "white", -- for light themes, set to 'black' or similar
			bold = true,
			nocombine = true,
		})
		leap.opts.highlight_unlabeled_phase_one_targets = true
	end,
}

return M
