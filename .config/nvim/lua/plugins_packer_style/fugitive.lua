local noremap = { noremap = true }

vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gpf", ":Git push --force<CR>", noremap)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FugitiveSmartQ", { clear = true }),
  pattern = { "fugitive-summary", "fugitiveblame", "fugitive" },
  command = "nmap <buffer> q gq",
})
