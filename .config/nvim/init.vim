" Vim Plug Package Management
call plug#begin('~/.local/share/nvim/plugged')
" LSP and Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" UI
Plug 'onsails/lspkind-nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'p00f/nvim-ts-rainbow'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'akinsho/nvim-bufferline.lua'
Plug 'kyazdani42/nvim-web-devicons'

" Colorscheme
Plug 'christianchiarulli/nvcode-color-schemes.vim'

" Movement
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Installed via homebrew
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Linter
Plug 'psf/black', { 'branch': 'stable' }

" Docker
Plug 'ekalinin/dockerfile.vim'

" Debuggers
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Git
Plug 'tpope/vim-fugitive'

" Syntax
Plug 'raimon49/requirements.txt.vim'

" Terminal
Plug 'kassio/neoterm'

call plug#end()

lua << EOF
  require('appearance');
  require('settings');
  require('mappings');
  require('lsp');
  require('debuggers');
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
autocmd BufWritePre *.py execute ':Black'

" Quickfix
autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
  \   q :cclose<cr>:lclose<cr>
autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
  \   bd|
  \   q | endif

packloadall
silent! helptags ALL
