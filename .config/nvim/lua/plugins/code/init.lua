local M = {
	require("plugins.code.conjure"),
	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			{
				"radenling/vim-dispatch-neovim",
				dependencies = {
					"tpope/vim-dispatch",
				},
			},
		},
		ft = { "clojure", "edn" },
		cmd = "Lein",
	},
	require("plugins.code.databases"),
	{
		"tpope/vim-sexp-mappings-for-regular-people",
		dependencies = {
			{ "guns/vim-sexp" },
		},
		ft = { "clojure", "scheme", "racket", "lisp", "elisp" },
	},
	{
		"eraserhd/parinfer-rust",
		build = "cargo build --release",
		ft = { "clojure", "scheme", "racket", "lisp", "elisp" },
	},
	require("plugins.code.toggleterm"),
	{
		"tpope/vim-fugitive",
		cmd = "G",
	},
	{
		"tpope/vim-rhubarb",
		dependencies = {
			"tpope/vim-fugitive",
		},
		cmd = "GBrowse",
	},
}
return M
