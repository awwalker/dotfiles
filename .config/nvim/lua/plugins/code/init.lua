local M = {
	require("plugins.code.conjure"),
	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			{ "tpope/vim-dispatch" },
			{ "radenling/vim-dispatch-neovim" },
		},
		ft = { "clojure", "edn" },
		cmd = "Lein",
	},
}
return M
