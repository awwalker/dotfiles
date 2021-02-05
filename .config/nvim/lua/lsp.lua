local M = {}

local lsp = require('lspconfig')

local sync_timeout = 10000

local document_format_sync = function()
    vim.lsp.buf.formatting_sync(nil, sync_timeout)
end

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

local document_organize_sync = function()
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, 't', true } }
    local params = vim.lsp.util.make_range_params()
    params.context = context
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, sync_timeout)
    if not result then return
    elseif #result < 1 then return
    end
    result = result[1].result
    if not result then return
    elseif #result < 1 then return
    end
    local edit = result[1].edit
    if not edit then return end
    vim.lsp.util.apply_workspace_edit(edit)
end

M.document_format_and_organize_sync = function()
    document_format_sync()
    document_organize_sync()
end

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', '<leader>d', '<cmd> lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>t', '<cmd> lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>i', '<cmd> lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>r', '<cmd> lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>K', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>E', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader><space>', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<leader>f', '<cmd> lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap('n', '<leader>f', '<cmd> lua vim.lsp.buf.formatting()<CR>', opts)
    end

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            :hi LspReferenceRead cterm=bold ctermbg=red guibg=Clear
            :hi LspReferenceText cterm=bold ctermbg=red guibg=Clear
            :hi LstpReferenceWrite cterm=bold ctermbg=red guibg=Clear
            augroup lsp_document_highlight
                autocmd!
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
    end
    print("LSP Attached")
end

vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')
vim.api.nvim_set_keymap('i', '<c-space>', '<Plug>(completion_trigger)', { silent=true })

lsp.dockerls.setup{
    on_attach = on_attach,
}

lsp.gopls.setup{
    on_attach = on_attach,
}

lsp.pyls.setup{
    on_attach = on_attach,
    cmd = { '/Users/awalker/.pyenv/versions/neovim3/bin/pyls' },
}

lsp.sumneko_lua.setup{
    on_attach = on_attach,
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

lsp.tsserver.setup{
    on_attach = on_attach,
}

lsp.yamlls.setup{
    on_attach = on_attach,
}

vim.api.nvim_exec([[
augroup format
    autocmd!
    autocmd Filetype go autocmd BufWritePre * lua require"lsp".document_format_and_organize_sync()
    autocmd Filetype python autocmd BufWritePre * lua require"lsp".document_format_and_organize_sync()
augroup END
]], false)

return M
