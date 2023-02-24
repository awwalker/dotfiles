local M = {}

M.json = {
	filetypes = { "json" },
	extra_args = {
		"--tab-width",
		"2",
	},
}

M.md = {
	filetypes = { "markdown", "markdown.mdx" },
	extra_args = {
		"--print-witdh",
		"80",
		"--prose-wrap",
		"always",
	},
}

return M
