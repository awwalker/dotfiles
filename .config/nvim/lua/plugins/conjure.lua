-- =============================
--            CONJURE
-- =============================
-- vim.g["conjure#debug"] = true
vim.g["conjure#eval#gsubs"] = { ["comment"] = { "^%(comment[%s%c]", "(do " } }

-- autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)
vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
  pattern = "conjure-log-*",
  callback = function(params)
    vim.diagnostic.disable(0)
  end,
})
-- autocmd User ConjureEval if expand("%:t") =~ "^conjure-log-" | exec "normal G" | endif
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("ConjureEval", { clear = true }),
  pattern = "ConjureEval",
  callback = function(params)
    if string.match(vim.api.nvim_buf_get_name(0), "conjure%-log%-") then
      vim.api.nvim_exec([[normal G]], true)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ConjureSmartQ", { clear = true }),
  pattern = "conjure-log-*",
  command = "nmap <buffer> q gq",
})

-- ============================
--           MAPPINGS
-- ============================
local noremap = { noremap = true }
vim.api.nvim_set_keymap("n", "<localleader>rt", "<cmd> CcaNreplRunCurrentTest<CR>", noremap)
vim.api.nvim_set_keymap("n", "<localleader>rn", "<cmd> CcaNreplRunTestsInTestNs<CR>", noremap)
vim.api.nvim_set_keymap("n", "<localleader>le", "<cmd> ConjureCljLastException <CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>di", "<cmd> ConjureCljDebugInit<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>c", "<cmd> ConjureCljDebugInput continue<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>si", "<cmd> ConjureCljDebugInput in<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>so", "<cmd> ConjureCljDebugInput out<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>l", "<cmd> ConjureCljDebugInput locals<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd> ConjureCljDebugInput next<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>de", "<cmd> ConjureCljDebugInput eval<CR>", noremap)
