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
--            ADAPTERS
-- =============================
dap.adapters.node2 = typescript.adapters.node2
dap.adapters.go = go.adapters.go
dap.adapters.dlv_spawn = go.adapters.dlv_spawn
dap.adapters.python = python.adapters.python

-- =============================
--         CONFIGURATIONS
-- =============================
dap.configurations.go = go.configurations
dap.configurations.python = python.configurations
dap.configurations.typescript = typescript.configurations
