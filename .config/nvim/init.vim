" Vim Plug Package Management
set nocompatible
filetype off
set rtp+=/usr/local/opt/fzf
call plug#begin('~/.local/share/nvim/plugged')
Plug 'neovim/neovim'
" Plug 'numirias/semshi'

Plug 'itchyny/lightline.vim'
Plug 'sinetoami/lightline-neomake'

" UI
" Plug 'Raimondi/delimitMate'
Plug 'ntpeters/vim-better-whitespace'
Plug 'luochen1990/rainbow'
Plug 'jaredgorski/spacecamp'

" Movement
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-surround'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" GIT
Plug 'airblade/vim-gitgutter'

" JSON
" Plug 'tpope/vim-jdaddy'

" Linter
Plug 'neomake/neomake'

" Docker
Plug 'ekalinin/dockerfile.vim'

" GO
" Plug 'fatih/vim-go'
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" TS/JS
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
" Plug 'mxw/vim-jsx'
" Plug 'pangloss/vim-javascript'
" Plug 'othree/javascript-libraries-syntax.vim'

" Debuggers
" Plug 'sebdah/vim-delve'
Plug 'puremourning/vimspector'


" Snippets
Plug 'honza/vim-snippets'

" Text
Plug 'junegunn/limelight.vim'
call plug#end()

filetype plugin indent on
colorscheme spacecamp
syntax enable
let g:python_host_prog = '/Users/awalker/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/awalker/.pyenv/versions/neovim3/bin/python'
let g:black_virtualenv = '/Users/awalker/.pyenv/versions/neovim3'

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
" Lightline Plugin
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ 'colorscheme': 'powerline',
      \ 'component_expand': {
      \   'coc_error'        : 'LightlineCocErrors',
      \   'coc_warning'      : 'LightlineCocWarnings',
      \   'coc_info'         : 'LightlineCocInfos',
      \   'coc_hint'         : 'LightlineCocHints',
      \   'coc_fix'          : 'LightlineCocFixes',
      \   'neomake_infos': 'lightline#neomake#infos',
      \   'neomake_warnings': 'lightline#neomake#warnings',
      \   'neomake_errors': 'lightline#neomake#errors',
      \   'neomake_ok': 'lightline#neomake#ok',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'],
      \             [ 'fugitive', 'filename' ],
      \             [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \           ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'neomake_warnings', 'neomake_errors', 'neomake_infos', 'neomake_ok' ],
      \              [ 'gitbranch'],
      \            ]
      \ },
      \ 'inactive' : {
      \   'left': [ [ 'mode' ],
      \             [ 'filename' ]
      \           ],
      \   'right': [ [ 'lineinfo' ],
      \            ],
      \ },
      \ 'tabline' : {
      \   'left'  : [ [ 'tabs' ] ],
      \   'right' : [ [ 'close' ], [ 'session' ] ],
      \ },
      \ 'tab' : {
      \   'active' : [ 'tabnum', 'filename', 'fticon', 'modified' ],
      \   'inactive' : [ 'tabnum', 'filename', 'fticon', 'modified' ],
      \ },
\ }
let g:lightline.component_type = {
\ 'coc_error'        : 'error',
\ 'coc_warning'      : 'warning',
\ 'coc_info'         : 'tabsel',
\ 'coc_hint'         : 'middle',
\ 'coc_fix'          : 'middle',
\ 'neomake_warnings': 'warning',
\ 'neomake_errors': 'error',
\ 'neomake_ok': 'left',
\ }

" function! s:lightline_coc_diagnostic(kind, sign) abort
"   let info = get(b:, 'coc_diagnostic_info', 0)
"   if empty(info) || get(info, a:kind, 0) == 0
"     return ''
"   endif
"   try
"     let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
"   catch
"     let s = ''
"   endtry
"   return printf('%s %d', s, info[a:kind])
" endfunction

" function! LightlineCocErrors() abort
"   return s:lightline_coc_diagnostic('error', 'error')
" endfunction
" 
" function! LightlineCocWarnings() abort
"   return s:lightline_coc_diagnostic('warning', 'warning')
" endfunction
" 
" function! LightlineCocInfos() abort
"   return s:lightline_coc_diagnostic('information', 'info')
" endfunction
" 
" function! LightlineCocHints() abort
"   return s:lightline_coc_diagnostic('hints', 'hint')
" endfunction
" \ }
" 
" autocmd User CocDiagnosticChange call lightline#update()

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction
set termguicolors
set background=dark
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{())}]
set number " show line numbers
set showcmd " show command in bottom bar

" searching
set incsearch " search as characters are entered
set smartcase " case insensitive if no caps entered.
set hlsearch " highlight matches

" turn off search highlight
nnoremap <leader>x :noh<CR>

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

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y

" yank current file name and line number
nnoremap <leader>yn :let @*=expand("%") . ':' . line(".")<CR>

" paste from clipboard
nmap <leader>p "+gP

nnoremap gob  :s/\((\zs\\|,\ *\zs\\|)\)/\r&/g<CR><Bar>:'[,']normal ==<CR>

" Golang
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_interfaces = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_extra_types = 1
" let g:go_auto_type_info = 0
" let g:go_fmt_command = "goimports"
" 
" " Disable GOPLS for golang
" let g:go_def_mapping_enabled = 0
" let g:go_code_completion_enabled = 0
" let g:go_doc_keywordprg_enabled = 0
" let g:go_info_mode = 'gopls'
" au FileType go nmap <leader>b :DlvToggleBreakpoint <CR>
" au FileType go nmap <leader>B :DlvClearAll <CR>
" au FileType go nmap <leader>ch :GoChannelPeers <CR>

" Typescript
function SetTSOpts()
    set tabstop=2 " number of visual spaces per TAB
    set softtabstop=2 " number of spaces in tab when editing
    set shiftwidth=2
    set expandtab	" tabs are spaces
endfunction
au FileType typescript call SetTSOpts()

" Neomake
let g:neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
let g:neomake_python_enabled_makers = [ 'python', 'flake8']
let g:neomake_go_gometalinter_maker = {
  \ 'args': [
  \   '--tests',
  \   '--enable-gc',
  \   '--concurrency=3',
  \   '--fast',
  \   '-D', 'aligncheck',
  \   '-D', 'dupl',
  \   '-D', 'gocyclo',
  \   '-D', 'gotype',
  \   '-E', 'errcheck',
  \   '-E', 'misspell',
  \   '-E', 'unused',
  \   '%:p:h',
  \ ],
  \ 'append_file': 0,
  \ 'errorformat':
  \   '%E%f:%l:%c:%trror: %m,' .
  \   '%W%f:%l:%c:%tarning: %m,' .
  \   '%E%f:%l::%trror: %m,' .
  \   '%W%f:%l::%tarning: %m'
  \ }

" Debugging
nnoremap <silent> <leader>b <Plug>(VimspectorToggleBreakpoint)
nnoremap <silent> <leader>c <Plug>(VimspectorContinue)
nnoremap <silent> <leader>s <Plug>(VimspectorStepOver)


" RAINBOW
let g:rainbow_active = 1

" COC
" set completeopt=longest,menuone " auto complete setting
" inoremap <silent><expr> <c-space>
""       \ pumvisible() ? "\<C-n>" :
""       \ <SID>check_back_space() ? "\<c-space>" :
"       \ coc#refresh()
" 
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" inoremap <silent><expr> <c-r> coc#refresh()
"" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" 
" " Remap keys for gotos
" nmap <silent> <leader>d <Plug>(coc-definition)
" nmap <silent> <leader>t <Plug>(coc-type-definition)
" nmap <silent> <leader>i <Plug>(coc-implementation)
" nmap <silent> <leader>n <Plug>(coc-references)
" nmap <silent> <leader>e <Plug>(coc-diagnostic-next-error)
" nmap <leader>r <Plug>(coc-rename)
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" 
" " Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
" 
" " Use K for show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if &filetype == 'vim'
"     execute 'h '.expand('<cword>')
"   else
"     call CocActionAsync('doHover')
"   endif
" endfunction

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocActionAsync('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Searching
" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Function to create the custom floating window
function! FloatingFZF()
    let width = float2nr(&columns * 0.9)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
               \ 'row': (&lines - height) / 2,
               \ 'col': (&columns - width) / 2,
               \ 'width': width,
               \ 'height': height }

    let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

nnoremap <c-f> :Files<CR>
nnoremap <silent> <c-g> :Rg <C-R><C-W><Cr>
nnoremap <c-b> :Buffers<CR>
nnoremap <leader>h :History:<CR>

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*~

packloadall
silent! helptags ALL
