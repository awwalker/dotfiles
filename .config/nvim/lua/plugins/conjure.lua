-- =============================
--            CONJURE
-- =============================
vim.g.conjure = {
  debug = true,
}

vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
  pattern = "conjure-log-*",
  callback = function(params)
    vim.diagnostic.disable(0)
  end,
})
