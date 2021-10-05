local api = vim.api

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

M.capabilities = capabilities

-- Credit https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
function M.post_attach(client)
  if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync()]]
      vim.cmd [[augroup END]]
  end

  local opts = { noremap = true, silent = true }

  local function buf_set_keymap(mode, mapping, command)
      api.nvim_buf_set_keymap(0, mode, mapping, command, opts)
  end

  api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')


  buf_set_keymap('n', '<leader>d', '<cmd> lua vim.lsp.buf.definition()<CR>')
  buf_set_keymap('n', '<leader>t', '<cmd> lua vim.lsp.buf.type_definition()<CR>')
  buf_set_keymap('n', '<leader>i', '<cmd> lua vim.lsp.buf.implementation()<CR>')
  buf_set_keymap('n', '<leader>r', '<cmd> lua vim.lsp.buf.references()<CR>')
  buf_set_keymap('n', '<leader>K', '<cmd> lua vim.lsp.buf.hover()<CR>')
  buf_set_keymap('n', '<leader>e', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_set_keymap('n', '<leader>E', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_set_keymap('n', '<leader>u', '<cmd> lua vim.lsp.buf.incoming_calls()<CR>')
  buf_set_keymap('n', '<leader>U', '<cmd> lua vim.lsp.buf.outgoing_calls()<CR>')

end

return M
