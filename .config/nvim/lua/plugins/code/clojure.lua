local M = {
	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			"radenling/vim-dispatch-neovim",
			-- tpope; latest tag (v1.8, 2019) is ~50 commits behind master.
			{ "tpope/vim-dispatch", version = false },
		},
		ft = { "clojure", "edn" },
		cmd = { "Lein", "Clj" },
	},
	{
		"julienvincent/nvim-paredit",
		ft = { "clojure", "edn" },
		config = function()
			require("nvim-paredit").setup()
		end,
	},
	{
		"eraserhd/parinfer-rust",
		-- Latest tag (v0.5.0) is ~45 commits behind master.
		version = false,
		build = "cargo build --release",
		event = "InsertCharPre",
		ft = { "clojure", "scheme", "racket", "lisp", "elisp" },
	},
}

return M
