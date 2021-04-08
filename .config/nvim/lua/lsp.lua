local lsp = require('lspconfig')
local compe = require('compe')
local kind = require('lspkind')

local home = os.getenv('HOME')
-- =============================
--           LSP
-- =============================

_G.lsp_organize_imports = function()
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "table", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = "textDocument/codeAction"
  local timeout = 1000 -- ms

  local resp = vim.lsp.buf_request_sync(0, method, params, timeout)
  if not resp then return end

  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if resp[client.id] then
      local result = resp[client.id].result
      if not result or not result[1] then return end

      local edit = result[1].edit
      vim.lsp.util.apply_workspace_edit(edit)
    end
  end
end

local function on_attach(client, bufnr)
  if client.resolved_capabilities.code_action then
    vim.api.nvim_exec([[
      augroup lsp_organize_imports
        autocmd!
        autocmd BufWritePre <buffer> lua lsp_organize_imports()
      augroup END
    ]], false)
  end

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_format
        autocmd!
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]], false)
  end
end

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

lsp.gopls.setup{ on_attach = on_attach }

-- lsp.pyright.setup{
-- settings = {
--   python = {
--     venvPath = '/Users/awalker/.pyenv/versions/3.6.5';
--   }
-- }
-- }
lsp.pyls.setup{
  cmd = { home .. '/.pyenv/versions/neovim3/bin/pyls' },
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
  on_attach = on_attach,
}

lsp.tsserver.setup{ on_atach = on_attach }

lsp.yamlls.setup{}

-- =============================
--             UI
-- =============================
kind.init()

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
    ultisnips = true;
  };
}
