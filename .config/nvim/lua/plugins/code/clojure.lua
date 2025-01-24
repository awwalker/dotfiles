local M = {
	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			{
				"radenling/vim-dispatch-neovim",
				"tpope/vim-dispatch",
			},
		},
		ft = { "clojure", "edn" },
		cmd = { "Lein", "Clj" },
	},
	{
		"julienvincent/nvim-paredit",
		ft = { "clojure", "edn" },
		config = true,
	},
	{
		"eraserhd/parinfer-rust",
		branch = "master",
		version = false,
		build = "cargo build --release",
		event = "InsertCharPre",
		ft = { "clojure", "scheme", "racket", "lisp", "elisp" },
	},
}

return M
