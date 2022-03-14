-- Install packer
local install_path = "~/.local/share/nvim/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	vim.cmd([[ packadd packer.nvim ]])
end

local use = require("packer").use
require("packer").startup(function()
	-- Packer.
	use("wbthomason/packer.nvim")
	-- UI.
	use("christianchiarulli/nvcode-color-schemes.vim")
	use("akinsho/nvim-bufferline.lua")
	use({
		"glepnir/galaxyline.nvim",
		branch = "main",
		requires = { { "kyazdani42/nvim-web-devicons" } },
	})
	use("ntpeters/vim-better-whitespace")
	use("karb94/neoscroll.nvim")

	-- LSP and Autocompletion.
	-- Snippets.
	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")
	use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
	use({
		"hrsh7th/nvim-cmp",
		requires = { { "onsails/lspkind-nvim" } },
	})
	use("hrsh7th/cmp-nvim-lsp")
	-- Treesitter.
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("p00f/nvim-ts-rainbow")
	-- Telescope.
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-live-grep-raw.nvim" },
		},
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	-- DAP.
	use("mfussenegger/nvim-dap")
	use("theHamsta/nvim-dap-virtual-text")
	use({
		"mfussenegger/nvim-dap-python",
		requires = { { "mfussenegger/nvim-dap" } },
	})
	use({
		"leoluz/nvim-dap-go",
		requires = { { "mfussenegger/nvim-dap" } },
	})
	-- Movement.
	use("ggandor/lightspeed.nvim")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("chentau/marks.nvim")
	-- Git.
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	-- Terminal.
	use("akinsho/toggleterm.nvim")
	-- Command prompt.
	use({
		"VonHeikemen/fine-cmdline.nvim",
		requires = {
			{ "MunifTanjim/nui.nvim" },
		},
	})
	-- Clojure.
	use("Olical/conjure")
	use("Olical/aniseed")
	-- use when developing on conjure
	-- use("~/oss/conjure")
	use({
		"clojure-vim/vim-jack-in",
		requires = {
			{ "tpope/vim-dispatch" },
			{ "radenling/vim-dispatch-neovim" },
		},
	})
	use({
		"PaterJason/cmp-conjure",
	})
	use("bakpakin/fennel.vim")
	use("guns/vim-sexp")
	use("tpope/vim-sexp-mappings-for-regular-people")
	-- Databases.
	use({
		"tpope/vim-dadbod",
	})
	use({
		"kristijanhusak/vim-dadbod-completion",
		requires = {
			"kristijanhusak/vim-dadbod-ui",
		},
	})
	use({
		"kristijanhusak/vim-dadbod-ui",
	})
end)
