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
-- ============================
--           MAPPINGS
-- ============================
local noremap = { noremap = true }
vim.api.nvim_set_keymap("n", "<localleader>rt", "<cmd> ConjureCljRunCurrentTest <CR>", noremap)
vim.api.nvim_set_keymap("n", "<localleader>rf", "<cmd> ConjureCljRunCurrentNsTests <CR>", noremap)
vim.api.nvim_set_keymap("n", "<localleader>le", "<cmd> ConjureCljLastException <CR>", noremap)
