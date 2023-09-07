local M = {
	"ggandor/flit.nvim",
	dependencies = {
		"ggandor/leap.nvim",
	},
	event = "BufReadPre",
	opts = {
		multiline = true,
	},
}
return M
