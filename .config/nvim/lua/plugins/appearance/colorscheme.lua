local M = {
  "connorholyday/vim-snazzy",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[ colorscheme snazzy ]])
  end,
}

return M
