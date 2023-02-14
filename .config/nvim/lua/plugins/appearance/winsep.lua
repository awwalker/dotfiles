local M = {
  "nvim-zh/colorful-winsep.nvim",
  lazy = false,
  config = function()
    require('colorful-winsep').setup()
  end,
}

return M
