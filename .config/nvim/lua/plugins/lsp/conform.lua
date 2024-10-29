local M = {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre", "BufNewFile" },
		cmd = { "ConformInfo" },
		setup = { log_level = vim.log.levels.DEBUG },
		-- This will provide type hinting with LuaLS
		---@module "conform"
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				-- clojure = { "cljfmt " },
				lua = { "stylua" },
				markdown = { "markdownlint", "prettier" },
				python = { "isort", "black" },
				javascript = { "prettier", stop_after_first = true },
				json = { "prettier" },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500 },
			-- Customize formatters
			formatters = {
				prettier = {
					options = {
						json = "json",
						markdown = "markdown",
						["markdown.mdx"] = "mdx",
					},
				},
				stylua = {
					append_args = {
						"--config-path",
						vim.fn.expand("~/.config/stylua/stylua.toml"),
					},
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}

return M
