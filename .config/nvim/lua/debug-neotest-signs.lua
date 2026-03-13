-- Neotest Signs Diagnostic Script
-- Run this with :luafile ~/.config/nvim/lua/debug-neotest-signs.lua

local M = {}

function M.check_sign_definitions()
	print("\n=== Neotest Sign Definitions ===")
	local signs = { "neotest_passed", "neotest_failed", "neotest_running", "neotest_skipped" }
	for _, sign_name in ipairs(signs) do
		local sign_def = vim.fn.sign_getdefined(sign_name)
		if sign_def and #sign_def > 0 then
			print(string.format("✓ %s: text='%s', texthl='%s'", sign_name, sign_def[1].text or "", sign_def[1].texthl or ""))
		else
			print(string.format("✗ %s: NOT DEFINED", sign_name))
		end
	end
end

function M.check_signs_in_buffer()
	print("\n=== Signs in Current Buffer ===")
	local bufnr = vim.api.nvim_get_current_buf()
	local signs = vim.fn.sign_getplaced(bufnr, { group = "*" })
	
	if signs and #signs > 0 and signs[1].signs then
		for _, sign in ipairs(signs[1].signs) do
			print(string.format("Line %d: %s (priority: %s)", sign.lnum, sign.name, sign.priority or "default"))
		end
	else
		print("No signs found in current buffer")
	end
end

function M.check_neotest_status()
	print("\n=== Neotest Status Configuration ===")
	local ok, neotest = pcall(require, "neotest")
	if not ok then
		print("✗ Neotest not loaded")
		return
	end
	
	local config = require("neotest.config")
	print(string.format("Status signs enabled: %s", config.status.signs))
	print(string.format("Status virtual_text enabled: %s", config.status.virtual_text))
	print("\nConfigured icons:")
	print(string.format("  passed:  '%s'", config.icons.passed))
	print(string.format("  failed:  '%s'", config.icons.failed))
	print(string.format("  running: '%s'", config.icons.running))
	print(string.format("  skipped: '%s'", config.icons.skipped))
end

function M.check_highlight_groups()
	print("\n=== Neotest Highlight Groups ===")
	local groups = { "NeotestPassed", "NeotestFailed", "NeotestRunning", "NeotestSkipped" }
	for _, group in ipairs(groups) do
		local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
		if next(hl) then
			print(string.format("✓ %s: defined", group))
		else
			print(string.format("✗ %s: NOT DEFINED", group))
		end
	end
end

function M.check_signcolumn()
	print("\n=== Sign Column Configuration ===")
	print(string.format("signcolumn: %s", vim.wo.signcolumn))
	print(string.format("statuscolumn: %s", vim.o.statuscolumn))
end

function M.run_all()
	M.check_signcolumn()
	M.check_sign_definitions()
	M.check_highlight_groups()
	M.check_neotest_status()
	M.check_signs_in_buffer()
	print("\n=== Diagnostic Complete ===\n")
end

-- Auto-run if called directly
M.run_all()

return M
