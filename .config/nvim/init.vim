" Vim Plug Package Management
set nocompatible
filetype off
call plug#begin('~/.local/share/nvim/plugged')
" LSP and Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" UI
Plug 'onsails/lspkind-nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'akinsho/nvim-bufferline.lua'

" If you want to display icons, then use one of these plugins:
Plug 'kyazdani42/nvim-web-devicons' " lua

" Colorscheme
Plug 'christianchiarulli/nvcode-color-schemes.vim'

" Movement
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-surround'
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

call plug#end()

set mouse=a
filetype plugin indent on
set termguicolors
let g:nvcode_termcolors=256
syntax on
colorscheme snazzy
set cursorline

let g:python_host_prog = '/Users/awalker/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/awalker/.pyenv/versions/neovim3/bin/python'

set backup
set backupdir=~/.vim/_backups
set directory=~/.vim/_swaps

set autoread
au FocusGained * :checktime

let mapleader="," " leader is comma
set synmaxcol=500
set ttyfast
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4
set expandtab	" tabs are spaces
set backspace=indent,eol,start
let g:matchparen_timeout = 2
let g:matchparen_insert_timeout = 2
set splitbelow
set splitright
set textwidth=0
" ui
set nocursorline
set hidden
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{())}]
set number " show line numbers
set showcmd " show command in bottom bar

" searching
set incsearch " search as characters are entered
set smartcase " case insensitive if no caps entered.
set hlsearch " highlight matches

" folding
set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max
nnoremap <space> za
" move screen
nnoremap mt zt
nnoremap mb zb
nnoremap mm z.

set foldmethod=indent " fold based on indent level

" movement
" down a line
nnoremap j gj
" up a line
nnoremap k gk

" go to beginning
nnoremap B ^
" go to end
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>

" esc is now jk
inoremap jk <esc>

tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <C-W><C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-W><C-l> <C-\><C-N><C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Copy to clipboard
vnoremap  <leader>y  "+y

" yank current file name and line number
nnoremap <leader>yn :let @*=expand("%") . ':' . line(".")<CR>

" paste from clipboard
nmap <leader>p "+gP

augroup two_space_ft
  autocmd!
  autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType tf setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType proto setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType lua setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup end

" Linting
let g:black_linelength = 100
autocmd BufWritePre *.py execute ':Black'

lua << EOF
  -- LSP
  require('lsp')
  -- Appearance
  require('appearance')
  -- DAP
  require('debuggers')
EOF

let g:completion_enable_snippet = 'UltiSnips'

" RAINBOW
let g:rainbow_active = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*~

" GIT
nnoremap <leader>gs :G<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" Quickfix
autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
  \   q :cclose<cr>:lclose<cr>
autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
  \   bd|
  \   q | endif

" FZF
" Run FZF based on the cwd & git detection
" 1. Runs :Files, If cwd is not a git repository
" 2. Runs :GitFiles <cwd> If root is a git repository
fun! FzfOmniFiles()
  " Throws v:shell_error if is not a git directory
  let git_status = system('git status')
  if v:shell_error != 0
    :Files
  else
    " Reference examples which made this happen:
    " https://github.com/junegunn/fzf.vim/blob/master/doc/fzf-vim.txt#L209
    " https://github.com/junegunn/fzf.vim/blob/master/doc/fzf-vim.txt#L290
    " --exclude-standard - Respect gitignore
    " --others - Show untracked git files
    " dir: getcwd() - Shows file names relative to cwd
    let git_files_cmd = ":GitFiles --cached --others --exclude-standard"
    call fzf#vim#gitfiles('--cached --others --exclude-standard', {'dir': getcwd()})
  endif
endfun
nnoremap <silent> <C-p> :call FzfOmniFiles()<CR>
nnoremap <c-f> :Files <CR>
nnoremap <c-b> :Buffers <CR>
nnoremap <c-g> :Rg <C-R><C-W><CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

packloadall
silent! helptags ALL
