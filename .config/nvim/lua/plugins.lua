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
  use({ "akinsho/nvim-bufferline.lua", branch = "main" })
  use({
    "nvim-lualine/lualine.nvim",
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
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-nvim-lua")
  use("rcarriga/cmp-dap")
  -- Treesitter.
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("p00f/nvim-ts-rainbow")
  use("windwp/nvim-autopairs")
  use("nvim-treesitter/nvim-treesitter-context")
  -- Telescope.
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-live-grep-raw.nvim" },
    },
  })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({ "nvim-telescope/telescope-ui-select.nvim" })

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
  use("chentoast/marks.nvim")
  -- Git.
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")
  use({
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  use("ThePrimeagen/git-worktree.nvim")
  -- Terminal.
  use({ "akinsho/toggleterm.nvim", branch = "main" })
  -- Command prompt.
  use({
    "VonHeikemen/fine-cmdline.nvim",
    requires = {
      { "MunifTanjim/nui.nvim" },
    },
  })
  -- Clojure.
  use("Olical/conjure")
  -- use when developing on conjure
  -- use("~/oss/conjure")
  use("Olical/aniseed")
  use({
    "clojure-vim/vim-jack-in",
    -- removing dispatch to avoid opening a terminal tab.
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
  use({ "eraserhd/parinfer-rust", run = "cargo build --release" })
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
  use("pbogut/vim-dadbod-ssh")
  -- CSV
  use("chrisbra/csv.vim")
  -- Startup
  use({ "goolord/alpha-nvim", requires = {
    "kyazdani42/nvim-web-devicons",
  } })
  -- Notes
  use({
    "nvim-neorg/neorg",
    tag = "*",
    requires = { "nvim-lua/plenary.nvim" },
  })
end)
