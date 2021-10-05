" Vim Plug Package Management
call plug#begin('~/.local/share/nvim/plugged')
" LSP and Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'
Plug 'ray-x/lsp_signature.nvim'
Plug 'ray-x/lsp_signature.nvim'

" UI
Plug 'onsails/lspkind-nvim'
Plug 'ntpeters/vim-better-whitespace'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'p00f/nvim-ts-rainbow' " rainbow parens
Plug 'nvim-treesitter/nvim-treesitter-textobjects' " additional text objects

Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'akinsho/nvim-bufferline.lua'
Plug 'kyazdani42/nvim-web-devicons'

" Colorscheme
Plug 'christianchiarulli/nvcode-color-schemes.vim'

" Movement
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Debuggers
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Git
Plug 'tpope/vim-fugitive'

" Terminal
Plug 'akinsho/toggleterm.nvim'

call plug#end()

lua << EOF
  require('settings');

  require('plugins.icons');
  require('plugins.kind');
  require('plugins.bufferline');
  require('plugins.galaxyline');
  require('plugins.cmp');
  require('plugins.treesitter');

  require('plugins.signature');
  require('plugins.lspconfig');
  require('plugins.dap');
  require('plugins.telescope');
  require('plugins.toggleterm');
  require('lsp');

  require('mappings');
EOF

au FocusGained * :checktime

augroup two_space_ft
  autocmd!
  autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType tf setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType proto setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType lua setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup end

" Linting
" autocmd BufWritePre *.py execute ':Black'

" Quickfix
autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
  \   q :cclose<cr>:lclose<cr>
autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
  \   bd|
  \   q | endif

packloadall
silent! helptags ALL
