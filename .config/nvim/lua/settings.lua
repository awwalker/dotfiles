-- =============================
--          SETTTINGS
-- =============================
local home = os.getenv('HOME')

-- GLOBALS
vim.g.mapleader = ',';
vim.g.python3_host_prog = home .. '/.pyenv/versions/neovim3/bin/python';

vim.o.autoread = true;
vim.o.completeopt = 'menuone,noselect'
vim.o.mouse = 'a';
vim.o.ttyfast = true;

-- BLACK
vim.g.black_linelength = 100;

-- FZF
vim.g.fzf_action = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-s'] = 'split',
  ['ctrl-v'] = 'vsplit',
}
vim.g.fzf_buffers_jump = 1;

-- ULTISNIPS
vim.g.UltiSnipsExpandTrigger = '<tab>';
vim.g.UltiSnipsJumpForwardTrigger = '<c-p>';
vim.g.UltiSnipsJumpBackwardTrigger = '<c-n>';

-- BACKUPS
vim.o.backup = true;
vim.o.backupdir = home .. '/.nvim/_backups';
vim.o.directory = home .. '/.nvim/_swaps';

-- SEARCH
vim.o.incsearch = true; -- As chars entered.
vim.o.ignorecase = true;
vim.o.smartcase = true;
vim.o.hlsearch = true;

-- COLORS
vim.o.termguicolors = true;
vim.o.syntax = 'on';
vim.g.nvcode_termcolors = 256;
vim.cmd [[ color snazzy ]]

-- LINES
vim.o.cursorline = true;
vim.o.tabstop = 4;
-- vim.o.softtabstop = 4;
vim.o.shiftwidth = 4;
vim.o.expandtab = true;
vim.o.backspace = 'indent,eol,start';
vim.o.textwidth = 0;
vim.o.hidden = true;
vim.o.lazyredraw = true; -- Redraw only as needed.
vim.o.showmatch = true; -- Highlight matching parens.


-- SIDEBAR
vim.o.number = true; -- Showw line numbers.
vim.o.showcmd = true; -- Show command in bottom bar.

-- IGNORANCE
vim.o.wildignore = vim.o.wildignore .. '*/tmp/*,*.so,*.swp,*.zip,*~';

-- FOLDING
vim.o.foldenable = true;
vim.o.foldlevelstart = 10;
vim.o.foldnestmax = 10;
vim.o.foldmethod = 'indent';

-- SPLITS
vim.o.splitbelow = true;
vim.o.splitright = true;
