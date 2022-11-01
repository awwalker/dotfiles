-- =============================
--              DAP
-- =============================
local dap = require("dap")
local dap_ui = require("nvim-dap-virtual-text")
-- Language specific configurations.
local typescript = require("plugins.debuggers.typescript")
local go = require("plugins.debuggers.go")
local python = require("plugins.debuggers.python")

dap.set_log_level("TRACE") -- logs live at ~/.cache/nvim/dap.log

-- Enable virtual text.
dap_ui.setup({
  commented = true,
})
-- Fancy breakpoint symbol.
local breakpoint = "DapBreakpoint"
local logpoint = "DapLogPoint"
local stopped = "DapStopped"

vim.fn.sign_define(breakpoint, { text = "⭕", texthl = breakpoint, linehl = "", numhl = "" })
vim.fn.sign_define(logpoint, { text = "🟡", texthl = logpoint, linehl = "", numhl = "" })
vim.fn.sign_define(stopped, { text = "🔴", texthl = stopped, linehl = "debugPC", numhl = "" })

-- Auto completion in REPL.
vim.cmd([[  au FileType dap-repl lua require('dap.ext.autocompl').attach() ]])

-- =============================
--           ADAPTERS
-- =============================
dap.adapters.node2 = typescript.adapters.node2
dap.adapters.go = go.adapters.go
dap.adapters.dlv_spawn = go.adapters.dlv_spawn
dap.adapters.python = python.adapters.python

-- ============================
--        CONFIGURATIONS
-- ============================
dap.configurations.go = go.configurations
dap.configurations.python = python.configurations
dap.configurations.typescript = typescript.configurations

-- ============================
--           MAPPINGS
-- ============================
local silent = { silent = true }
vim.api.nvim_set_keymap("n", "<leader>c", '<cmd> lua require"dap".continue() <CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>n", '<cmd> lua require"dap".step_over() <CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>b", '<cmd> lua require"dap".toggle_breakpoint() <CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>dr", '<cmd> lua require"dap".repl.open() <CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>si", '<cmd> lua require"dap".step_into() <CR>', silent)
vim.api.nvim_set_keymap("n", "<leader>so", '<cmd> lua require"dap".step_out() <CR>', silent)
-- handled per language in ftplugin
-- vim.api.nvim_set_keymap("n", "<leader>dt", '<cmd> lua require"dap-python".test_method()<CR>', silent)
