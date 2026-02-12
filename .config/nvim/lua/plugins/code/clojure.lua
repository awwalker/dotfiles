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
		config = function()
			require("nvim-paredit").setup()
		end,
	},
	{
		dir = "~/oss/parinfer-rust",
		build = "cargo build --release",
		event = "InsertCharPre",
		ft = { "clojure", "scheme", "racket", "lisp", "elisp" },
	},
}

return M
