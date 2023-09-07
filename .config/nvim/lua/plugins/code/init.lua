local M = {
	require("plugins.code.conjure"),
	require("plugins.code.csv"),
	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			{
				"radenling/vim-dispatch-neovim",
				"tpope/vim-dispatch",
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
		branch = "master",
		version = false,
		build = "cargo build --release",
		event = "InsertCharPre",
		ft = { "clojure", "scheme", "racket", "lisp", "elisp" },
	},
	require("plugins.code.toggleterm"),
	require("plugins.code.git"),
}
return M
