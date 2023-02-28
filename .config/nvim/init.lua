local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("settings")
require("mappings")
require("statuscol")

require("lazy").setup("plugins", {
	spec = "plugins",
	defaults = { lazy = true, version = "*" },
	checker = { enabled = true },
	dev = {
		path = "~/oss",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				-- easier to view matching parens.
				-- "matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				-- required to view java source files.
				-- "zipPlugin",
			},
		},
	},
})
