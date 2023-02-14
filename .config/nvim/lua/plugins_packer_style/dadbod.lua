-- =============================
--            DADBOD
-- =============================
-- connections managed as JSON in `~/.local/share/nvim/db_ui/connections.json`

-- ============================
--           MAPPINGS
-- ============================
local noremap = { noremap = true }
vim.api.nvim_set_keymap("n", "<leader>du", ":DBUIToggle<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>df", ":DBUIFindBuffer<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>di", ":DBUILastQueryInfo<Cr>", noremap)
