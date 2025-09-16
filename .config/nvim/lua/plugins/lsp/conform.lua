local M = {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre", "BufNewFile" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				log_level = vim.log.levels.DEBUG,
				-- This will provide type hinting with LuaLS
				---@module "conform"
				-- Define your formatters
				formatters_by_ft = {
					-- clojure = { "cljfmt " },
					lua = { "stylua" },
					markdown = { "prettier_md" }, --, "markdownlint" },
					python = { "isort", "black" },
					javascript = { "prettier", stop_after_first = true },
					json = { "prettier" },
					xml = { "xmlformat" },
				},
				-- Set up format-on-save
				format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
				-- Customize formatters
				formatters = {
					prettier = {
						options = {
							ft_parsers = {
								json = "json",
								["markdown.mdx"] = "mdx",
							},
						},
					},
					prettier_md = {
						command = "prettier",
						args = {
							"--parser",
							"markdown",
							"--print-width",
							"80",
							"--prose-wrap",
							"always",
							"--stdin-filepath",
							"$FILENAME",
						},
						-- "--prose-wrap", "always", "$FILENAME" },
					},
					stylua = {
						append_args = {
							"--config-path",
							vim.fn.expand("~/.config/stylua/stylua.toml"),
						},
					},
					markdown = {},
				},
			})
		end,
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}

return M
