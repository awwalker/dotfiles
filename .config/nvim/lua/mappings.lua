-- =============================
--            MAPPINGS
-- =============================
local utils = require('utils');
local silent = { silent=true };
local noremap = { noremap=true };
local noremap_silent = { noremap=true, silent=true }
local noremap_silent_expr = { noremap=true, silent=true, expr=true }

function _G.filepath_and_lineno()
  local path_and_no = string.format('%s:%s', vim.fn.expand('%:p'), vim.fn.line('.'))
  local subbed = string.gsub(path_and_no, os.getenv('PLAID_PATH') .. '/', '');
  vim.api.nvim_command(string.format('call setreg("+", "%s")', subbed, {}))
end

function _G.terminal_buffer()
  vim.cmd('botright Tnew');
  vim.api.nvim_feedkeys(utils.t':<c-f>i:T ', 'n', true);
end

-- NATIVE
vim.api.nvim_set_keymap('n', '<space>', 'za', noremap);
-- Move the screen.
vim.api.nvim_set_keymap('n', 'mt', 'zt', noremap); -- Top.
vim.api.nvim_set_keymap('n', 'mb', 'zb', noremap); -- Middle.
vim.api.nvim_set_keymap('n', 'mm', 'z.', noremap); -- Bottom.

-- Movement.
vim.api.nvim_set_keymap('n', 'j', 'gj', noremap);
vim.api.nvim_set_keymap('n', 'k', 'gk', noremap);
vim.api.nvim_set_keymap('n', 'B', '^', noremap);
vim.api.nvim_set_keymap('n', 'E', '$', noremap);

-- Shortcuts
vim.api.nvim_set_keymap('i', 'jk', '<esc>', noremap);
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', noremap); -- Copy.
vim.api.nvim_set_keymap('n', '<leader>p', '"+gp', noremap); -- Paste.
vim.api.nvim_set_keymap('n', '<leader>yn', '<cmd> lua filepath_and_lineno() <CR>', noremap); -- Get current relative filepath and line number of cursor.

-- Terminal
vim.api.nvim_set_keymap('t', '<esc>', '<C-\\><C-n>', noremap);
vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', noremap);

-- Buffers
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', noremap);
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', noremap);
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', noremap);
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', noremap);
vim.api.nvim_set_keymap('n', '<c-t>', '<cmd> lua terminal_buffer() <CR>', noremap); -- Open new neoterm buffer and command prompt.

-- TABS
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd> lua vim.cmd("tabedit %") <CR>', noremap); -- Pull buffer into new tab.
vim.api.nvim_set_keymap('n', '<leader>tc', '<cmd> lua vim.cmd("tabclose") <CR>', noremap); -- Close current tab.
vim.api.nvim_set_keymap('t', '<leader>tf', '<cmd> lua vim.cmd("tabedit %") <CR>', noremap); -- Pull terminal buffer into new tab.
vim.api.nvim_set_keymap('t', '<leader>tc', '<cmd> lua vim.cmd("tabclose") <CR>', noremap); -- Close current tab.

-- LSP
vim.api.nvim_set_keymap('n', '<leader>d', '<cmd> lua vim.lsp.buf.definition()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd> lua vim.lsp.buf.type_definition()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader>i', '<cmd> lua vim.lsp.buf.implementation()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader>r', '<cmd> lua vim.lsp.buf.references()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader>K', '<cmd> lua vim.lsp.buf.hover()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader>E', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', noremap_silent)
vim.api.nvim_set_keymap('n', '<leader><space>', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', noremap_silent)

vim.api.nvim_set_keymap('i', '<C-space>', [[compe#complete()]], noremap_silent_expr)
vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], noremap_silent_expr)
vim.api.nvim_set_keymap('i', '<C-c>', [[compe#close("<C-c>")]], noremap_silent_expr)
vim.api.nvim_set_keymap('i', '<C-p>', [[compe#close("<C-c>")]], noremap_silent_expr)

-- PLUGINS

-- DAP
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd> lua require"dap".continue()<CR>', silent);
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd> lua require"dap".step_over()<CR>', silent);
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd> lua require"dap".toggle_breakpoint()<CR>', silent);
vim.api.nvim_set_keymap('n', '<leader>dr', '<cmd> lua require"dap".repl.open()<CR>', silent);
vim.api.nvim_set_keymap('n', '<leader>si', '<cmd> lua require"dap".step_into()<CR>', silent);
vim.api.nvim_set_keymap('n', '<leader>so', '<cmd> lua require"dap".step_out()<CR>', silent);

-- FUGITIVE
vim.api.nvim_set_keymap('n', '<leader>gs', ':Gstatus<CR>', noremap);
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gdiffsplit<CR>', noremap);
vim.api.nvim_set_keymap('n', '<leader>gp', ':Gpush<CR>', noremap);

-- FZF
vim.api.nvim_set_keymap('n', '<c-f>', ':Files <CR>', noremap);
vim.api.nvim_set_keymap('n', '<c-b>', ':Buffers <CR>', noremap);
vim.api.nvim_set_keymap('n', '<c-g>', ':Rg <C-R><C-W><CR>', noremap);
