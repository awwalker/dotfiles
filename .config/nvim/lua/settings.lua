-- =============================
--          SETTTINGS
-- =============================
local home = os.getenv("HOME")

-- GLOBALS
vim.g.maplocalleader = ";"
vim.g.mapleader = ","
vim.g.python3_host_prog = home .. "/.pyenv/versions/neovim3/bin/python"

vim.o.autoread = true
vim.o.completeopt = "menu,menuone,noinsert"
vim.o.mouse = "a"
vim.o.ttyfast = true

-- BLACK
vim.g.black_linelength = 100

-- FZF
vim.g.fzf_action = {
	["ctrl-t"] = "tab split",
	["ctrl-s"] = "split",
	["ctrl-v"] = "vsplit",
}
vim.g.fzf_buffers_jump = 1

-- BACKUPS
vim.o.backup = true
vim.o.backupdir = home .. "/.nvim/_backups"
vim.o.directory = home .. "/.nvim/_swaps"

-- SEARCH
vim.o.incsearch = true -- As chars entered.
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- LINES
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
vim.bo.smartindent = true

vim.wo.cursorline = true
vim.o.backspace = "indent,eol,start"
vim.o.textwidth = 0
vim.o.hidden = true
vim.o.showmatch = true -- Highlight matching parens.

-- Fillchars
vim.opt.fillchars = {
	vert = "│",
	fold = "⠀",
	eob = " ", -- suppress ~ at EndOfBuffer
	--diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}

-- SIDEBAR
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.showcmd = true -- Show command in bottom bar.

-- IGNORANCE
vim.o.wildignore = vim.o.wildignore .. "*/tmp/*,*.so,*.swp,*.zip,*~"

-- FOLDING
vim.o.foldenable = true
vim.o.foldlevelstart = 10
vim.o.foldnestmax = 10
vim.o.foldmethod = "expr"

-- SPLITS
vim.o.splitbelow = true
vim.o.splitright = true

-- NETRW
vim.g.netrw_liststyle = 3

-- SEXP
vim.g.sexp_enable_insert_mode_mappings = false

-- DadBod SSH
vim.g.db_ssh_default_async = true

-- DIFF
-- vim.o.diffopt = 'filler,internal,closeoff,indet-heuristic,linematch:60,algorithm:histogram'
