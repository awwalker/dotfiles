-- =============================
--            MAPPINGS
-- =============================
local silent = { silent = true }
local noremap = { noremap = true }

local noremap_silent = { noremap = true, silent = true }
local lcl_open = false

function _G.filepath_and_lineno()
	local path_and_no = string.format("%s:%s", vim.fn.expand("%:p"), vim.fn.line("."))
	local subbed = string.gsub(path_and_no, os.getenv("PLAID_PATH") .. "/", "")
	vim.api.nvim_command(string.format('call setreg("+", "%s")', subbed, {}))
end

function _G.toggle_diagnostics()
	if lcl_open then
		vim.cmd("lcl")
		lcl_open = false
	else
		vim.lsp.diagnostic.set_loclist()
		lcl_open = true
	end
end

-- NATIVE
vim.api.nvim_set_keymap("n", "<space>", "za", noremap)

-- Move the screen.
vim.api.nvim_set_keymap("n", "mt", "zt", noremap) -- Top.
vim.api.nvim_set_keymap("n", "mb", "zb", noremap) -- Middle.
vim.api.nvim_set_keymap("n", "mm", "z.", noremap) -- Bottom.

-- Movement.
vim.api.nvim_set_keymap("n", "j", "gj", noremap)
vim.api.nvim_set_keymap("n", "k", "gk", noremap)
vim.api.nvim_set_keymap("n", "B", "^", noremap)
vim.api.nvim_set_keymap("n", "E", "$", noremap)

-- Shortcuts
vim.api.nvim_set_keymap("i", "jk", "<esc>", noremap)
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', noremap) -- Copy.
vim.api.nvim_set_keymap("n", "<leader>p", '"+gp', noremap) -- Paste.
vim.api.nvim_set_keymap("n", "<leader>yn", "<cmd> lua filepath_and_lineno() <CR>", noremap) -- Get current relative filepath and line number of cursor.

-- Terminal
vim.api.nvim_set_keymap("t", "<esc>", "<C-\\><C-n>", noremap)
vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n>", noremap)
vim.api.nvim_set_keymap("t", "<C-j>", [[<C-\><C-n><C-W>j]], noremap)
vim.api.nvim_set_keymap("t", "<C-k>", [[<C-\><C-n><C-W>k]], noremap)
vim.api.nvim_set_keymap("t", "<C-w><C-l>", [[<C-\><C-n><C-W>l]], noremap)
vim.api.nvim_set_keymap("t", "<C-w><C-h>", [[<C-\><C-n><C-W>h]], noremap)
vim.api.nvim_set_keymap("t", "<c-p>", [[<C-\><C-n><C-W>p]], noremap)
-- Clost the current terminal tab.
vim.api.nvim_set_keymap("t", "<leader>tc", '<cmd> lua vim.cmd("tabclose") <CR>', noremap)

-- Buffers
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w>j", noremap)
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w>k", noremap)
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w>l", noremap)
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", noremap)
vim.api.nvim_set_keymap("n", "<c-p>", "<c-w>p", noremap)

-- Macros
vim.api.nvim_set_keymap("n", "<leader>dt", '<cmd> r! date "+%Y-%m-%d %H:%M:%S" <CR>', noremap)

-- TABS
vim.api.nvim_set_keymap("n", "<leader>tf", '<cmd> lua vim.cmd("tabedit %") <CR>', noremap) -- Pull buffer into new tab.
vim.api.nvim_set_keymap("n", "<leader>tc", '<cmd> lua vim.cmd("tabclose") <CR>', noremap) -- Close current tab.

-- LSP
vim.api.nvim_set_keymap(
	"n",
	"<leader><space>",
	"<cmd> lua require('telescope.builtin').lsp_document_diagnostics() <CR>",
	noremap_silent
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>r",
	"<cmd> lua require('telescope.builtin').lsp_references() <CR>",
	noremap_silent
)

-- PLUGINS

-- DAP
vim.api.nvim_set_keymap("n", "<leader>c", '<cmd> lua require"dap".continue()<CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>n", '<cmd> lua require"dap".step_over()<CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>b", '<cmd> lua require"dap".toggle_breakpoint()<CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>dr", '<cmd> lua require"dap".repl.open()<CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>si", '<cmd> lua require"dap".step_into()<CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>so", '<cmd> lua require"dap".step_out()<CR>', silent)

-- FUGITIVE
vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", noremap)

-- TELESCOPE
vim.api.nvim_set_keymap("n", "<c-f>", [[:lua require('telescope.builtin').find_files()<CR>]], noremap_silent)
vim.api.nvim_set_keymap("n", "<c-b>", [[:lua require('telescope.builtin').buffers()<CR>]], noremap_silent)
vim.api.nvim_set_keymap("n", "<leader>f", [[:lua require('telescope.builtin').live_grep()<CR>]], noremap_silent)
vim.api.nvim_set_keymap("n", "<c-g>", [[:lua require('telescope.builtin').grep_string()<CR>]], noremap_silent)
