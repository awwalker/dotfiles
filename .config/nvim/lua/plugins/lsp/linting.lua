local function debounce(ms, fn)
	local timer = vim.loop.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end
local M = {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			linters_by_ft = {
				-- clojure = { "clj-kondo" },
				-- css = { "stylelint" },
				-- dockerfile = { "hadolint" },
				-- javascript = {},
				lua = { "luacheck" },
				markdown = { "markdownlint" },
				-- python = { "pylint" },
				-- sh = { "shellcheck" },
				-- typescript = {},
				-- toml = {},
				-- text = {},
				-- yaml = { "yamllint" },
			},
		},
		config = function()
			local lint = require("lint")
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = debounce(10, function()
					lint.try_lint()
				end),
			})
		end,
	},
}
return M
