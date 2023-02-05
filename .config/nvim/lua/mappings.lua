-- =============================
--            MAPPINGS
-- =============================
-- For <A-?> mappings to work in iTerm set <Alt> keys to Esc+ in iTerm prefs.
local noremap = { noremap = true }

-- Folds.
vim.api.nvim_set_keymap("n", "<space>", "za", noremap)
-- Move the screen.
vim.api.nvim_set_keymap("n", "mt", "zt", noremap) -- Top.
vim.api.nvim_set_keymap("n", "mb", "zb", noremap) -- Middle.

-- Movement.
vim.api.nvim_set_keymap("n", "j", "gj", noremap)
vim.api.nvim_set_keymap("n", "k", "gk", noremap)
vim.api.nvim_set_keymap("n", "B", "^", noremap)
vim.api.nvim_set_keymap("n", "E", "$", noremap)

-- Shortcuts
vim.api.nvim_set_keymap("i", "jk", "<esc>", noremap)
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', noremap) -- Copy.
vim.api.nvim_set_keymap("v", "<leader>Y", '"+Y', noremap) -- Copy.
vim.api.nvim_set_keymap("n", "<leader>p", '"+gp', noremap) -- Paste.
-- Terminal
vim.api.nvim_set_keymap("t", "<esc>", "<C-\\><C-n>", noremap)
vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n>", noremap)
vim.api.nvim_set_keymap("t", "<C-j>", [[<C-\><C-n><C-W>j]], noremap)
vim.api.nvim_set_keymap("t", "<C-k>", [[<C-\><C-n><C-W>k]], noremap)
vim.api.nvim_set_keymap("t", "<C-w><C-l>", [[<C-\><C-n><C-W>l]], noremap)
vim.api.nvim_set_keymap("t", "<C-w><C-h>", [[<C-\><C-n><C-W>h]], noremap)
vim.api.nvim_set_keymap("t", "<c-p>", [[<C-\><C-n><C-W>p]], noremap)
-- Close the current terminal tab.
vim.api.nvim_set_keymap("t", "<leader>tc", '<cmd> lua vim.cmd("tabclose") <CR>', noremap)

-- Buffers
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w>j", noremap)
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w>k", noremap)
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w>l", noremap)
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", noremap)
vim.api.nvim_set_keymap("n", "<c-p>", "<c-w>p", noremap)

-- Tabs
vim.api.nvim_set_keymap("n", "<leader>tf", '<cmd> lua vim.cmd("tabedit %") <CR>', noremap) -- Pull buffer into new tab.
vim.api.nvim_set_keymap("n", "<leader>tc", '<cmd> lua vim.cmd("tabclose") <CR>', noremap) -- Close current tab.
