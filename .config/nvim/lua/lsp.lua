local lsp = require('lspconfig')
local compe = require('compe')

local function debug_print (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. debug_print(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

-- =============================
--           LSP
-- =============================
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- disable virtual text
      virtual_text = true,

      -- show signs
      signs = true,
      underline = true,

      -- delay update diagnostics
      update_in_insert = false,
      -- display_diagnostic_autocmds = { "InsertLeave" },
    }
)

lsp.dockerls.setup{}

lsp.gopls.setup{}

lsp.pyls.setup{
    cmd = { '/Users/awalker/.pyenv/versions/neovim3/bin/pyls' },
}

lsp.sumneko_lua.setup{
    cmd = {
        '/Users/awalker/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server',
        '-E',
        '/Users/awalker/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua',
    },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
}

lsp.tsserver.setup{}

lsp.yamlls.setup{}

-- =============================
--          COMPLETION
-- =============================

compe.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    spell = true;
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

local opts = { noremap=true, silent=true }
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

vim.o.completeopt = "menuone,noselect"

buf_set_keymap('n', '<leader>d', '<cmd> lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', '<leader>t', '<cmd> lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<leader>i', '<cmd> lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<leader>r', '<cmd> lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<leader>K', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', '<leader>e', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<leader>E', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', '<leader><space>', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

vim.api.nvim_set_keymap('i', '<C-space>', [[compe#complete()]], { expr=true, noremap=true, silent=true })
vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], { expr=true, noremap=true, silent=true })
vim.api.nvim_set_keymap('i', '<C-c>', [[compe#close("<C-c>")]], { expr=true, noremap=true, silent=true })
vim.api.nvim_set_keymap('i', '<C-p>', [[compe#close("<C-c>")]], { expr=true, noremap=true, silent=true })
