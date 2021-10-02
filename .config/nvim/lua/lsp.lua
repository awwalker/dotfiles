local lsp = require('lspconfig')
local compe = require('compe')
local kind = require('lspkind')

local home = os.getenv('HOME')
-- =============================
--           LSP
-- =============================

_G.organize_imports_sync = function(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
end

local function on_attach(client, bufnr)
  if client.resolved_capabilities.code_action then
    vim.api.nvim_exec([[
      augroup lsp_organize_imports
        autocmd!
        autocmd BufWritePre <buffer> lua organize_imports_sync(1000)
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

lsp.dockerls.setup{}

lsp.gopls.setup{
  cmd = {"gopls", "serve"},
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 300,
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        -- Disable virtual_text
        virtual_text = false,
        signs = false,
        underline = false,
        update_in_insert = false,
      }
    )
  },
}
}

-- lsp.pyright.setup{
-- settings = {
--   python = {
--     venvPath = '/Users/awalker/.pyenv/versions/3.6.5';
--   }
-- }
-- }
lsp.pylsp.setup{
  cmd = { home .. '/.pyenv/versions/neovim3/bin/pylsp' },
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

lsp.yamlls.setup{ on_attach = on_attach }

lsp.clangd.setup{ on_attach = on_attach }
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
  throttle_time = 100;
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
