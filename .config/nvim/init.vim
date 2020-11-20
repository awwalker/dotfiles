" Vim Plug Package Management
set nocompatible
filetype off
set rtp+=/usr/local/opt/fzf
call plug#begin('~/.local/share/nvim/plugged')
Plug 'neovim/neovim'

" LSP and Completion
Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/diagnostic-nvim'

" UI
Plug 'ntpeters/vim-better-whitespace'
Plug 'luochen1990/rainbow'
Plug 'itchyny/lightline.vim'
Plug 'sinetoami/lightline-neomake'
Plug 'nvim-treesitter/nvim-treesitter'

" Colorscheme
Plug 'jaredgorski/spacecamp'

" Movement
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-surround'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

" Linter
Plug 'neomake/neomake'
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

call plug#end()

filetype plugin indent on
colorscheme spacecamp
set background=dark
set termguicolors
syntax enable
set cursorline
" colorscheme onehalfdark

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"go", "python", "json", "typescript"},
  highlight = {
    enable = true
  }
}
require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.highlighter.hl_map

--Misc
hlmap.error = nil
hlmap["punctuation.delimiter"] = "Delimiter"
hlmap["punctuation.bracket"] = nil
EOF


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
" Lightline Plugin
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ 'colorscheme': 'powerline',
      \ 'component_expand': {
      \   'neomake_infos':    'lightline#neomake#infos',
      \   'neomake_warnings': 'lightline#neomake#warnings',
      \   'neomake_errors':   'lightline#neomake#errors',
      \   'neomake_ok':       'lightline#neomake#ok',
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
      \   'left':  [ [ 'mode' ],
      \              [ 'filename' ]
      \            ],
      \   'right': [ [ 'lineinfo' ],
      \            ],
      \ },
      \ 'tabline': {
      \   'left':   [ [ 'tabs' ] ],
      \   'right':  [ [ 'close' ], [ 'session' ] ],
      \ },
      \ 'tab' : {
      \   'active':   [ 'tabnum', 'filename', 'fticon', 'modified' ],
      \   'inactive': [ 'tabnum', 'filename', 'fticon', 'modified' ],
      \ },
\ }
let g:lightline.component_type = {
\ 'neomake_warnings': 'warning',
\ 'neomake_errors':   'error',
\ 'neomake_ok':       'left',
\ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

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
nnoremap  <leader>y  "+y

" yank current file name and line number
nnoremap <leader>yn :let @*=expand("%") . ':' . line(".")<CR>

" paste from clipboard
nmap <leader>p "+gP
augroup two_space_ft
    autocmd!
    autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType ts setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType tf setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup end

" Linting
let g:neomake_go_enabled_makers = [ 'golangci_lint' ]
let g:neomake_python_enabled_makers = [ 'flake8' ]
let g:black_linelength = 100
autocmd BufWritePre *.py execute ':Black'

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" LSP
set completeopt=menuone,noinsert,noselect

"map <c-space> to manually trigger completion
imap <silent> <c-space> <Plug>(completion_trigger)

lua << EOF
  local on_attach_vim = function(client)
    require'completion'.on_attach(client)
    require'diagnostic'.on_attach(client)
    print("LSP Attached.")
  end

  require'lspconfig'.pyls.setup{
    on_attach=on_attach_vim,
    cmd={'/Users/awalker/.pyenv/versions/neovim3/bin/pyls'}
  }

  require'lspconfig'.gopls.setup{on_attach=on_attach_vim}

  require'lspconfig'.tsserver.setup{on_attach=on_attach_vim}
EOF

lua << EOF
  function goimports(timeoutms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local method = "textDocument/codeAction"
    local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
    if resp and resp[1] then
      local result = resp[1].result
      if result and result[1] then
        local edit = result[1].edit
        vim.lsp.util.apply_workspace_edit(edit)
      end
    end
    vim.lsp.buf.formatting()
  end
EOF

" DAP
lua << EOF
  local dap = require "dap"
  dap.adapters.python = {
    type = 'executable';
    command = os.getenv('HOME') .. '/.pyenv/versions/neovim3/bin/python';
    args = { '-m', 'debugpy.adapter' };
  }
  dap.configurations.python = {
    {
      type = 'python';
      request = 'launch';
      name = "Launch file";
      program = "${file}";
      pythonPath = function(adapter)
        local fh = io.popen("pyenv which python");
        local pyenvPath = fh:read('*a')
        fh:close()
        return pyenvPath
      end
    },
  }
EOF

nnoremap <silent> <leader>c :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>st :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>si :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>so :lua require'dap'.step_out()<CR>

autocmd BufWritePre *.go lua goimports(1000)

let g:diagnostic_enable_virtual_text = 1

nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>t <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>i <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>n <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>k <cmd>lua vim.lsp.buf.hover()<CR>

nmap <silent> <leader>E :PrevDiagnosticCycle<CR>
nmap <silent> <leader>e :NextDiagnosticCycle<CR>

let g:completion_enable_snippet = 'UltiSnips'

" RAINBOW
let g:rainbow_active = 1

" CLAP
let g:clap_open_action = { 'ctrl-t': 'tab split', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }
nnoremap <c-f> <cmd> :Clap files <CR>
nnoremap <c-b> <cmd> :Clap buffers <CR>
nnoremap <c-g> <cmd> :Clap grep ++query=<cword> <CR>
nnoremap <leader>vg <cmd> :Clap grep ++query=@visual <CR>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*~

" GIT
nnoremap <leader>gs :G<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

packloadall
silent! helptags ALL
