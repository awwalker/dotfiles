-- =============================
--         FINE-CMDLINE
-- =============================
require("fine-cmdline").setup()
-- ============================
--           MAPPINGS
-- ============================
local noremap_silent = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
  "n",
  "<localleader><localleader>",
  "<cmd> lua require('fine-cmdline').open()<CR>",
  noremap_silent
)
