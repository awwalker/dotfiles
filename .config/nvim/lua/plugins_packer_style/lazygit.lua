local Terminal = require("toggleterm.terminal").Terminal
local noremap = { noremap = true, silent = true }

local function close_terminal_on_zero_exit(terminal, _, exit_code)
  if exit_code == 0 then
    terminal:close()
  end
end

local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
  on_exit = close_terminal_on_zero_exit,
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", noremap)
  end,
})

local dotfileslazygit = Terminal:new({
  cmd = "lazygit --git-dir=$HOME/.config --work-tree=$HOME",
  direction = "float",
  hidden = true,
  on_exit = close_terminal_on_zero_exit,
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", noremap)
  end,
})

function _lazygit_toggle()
  if string.find(vim.loop.cwd(), vim.call("expand", "~/.config")) then
    dotfileslazygit:toggle()
  else
    lazygit:toggle()
  end
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", noremap)
