local noremap = { noremap = true }

vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", noremap)
