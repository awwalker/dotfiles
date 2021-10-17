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
	-- LSP and Autocompletion.
	use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
	use({
		"hrsh7th/nvim-cmp",
		requires = { { "onsails/lspkind-nvim" } },
	})
	use("hrsh7th/cmp-nvim-lsp")
	use("ray-x/lsp_signature.nvim")
	-- Snippets.
	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")
	-- Treesitter.
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("p00f/nvim-ts-rainbow")
	use({ -- Telescope.
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	use("mfussenegger/nvim-dap") -- DAP.
	use("theHamsta/nvim-dap-virtual-text")
	-- Movement.
	use("rhysd/clever-f.vim")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("chentau/marks.nvim")
	-- Git.
	use("tpope/vim-fugitive")
	-- Terminal.
	use("akinsho/toggleterm.nvim")
end)
