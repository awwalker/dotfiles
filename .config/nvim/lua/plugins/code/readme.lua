local M = {
	{
		"vinnymeller/swagger-preview.nvim",
		cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
		build = "npm i",
		config = true,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,

		-- For `nvim-treesitter` users.
		priority = 49,

		-- For blink.cmp's completion
		-- source
		dependencies = {
			"saghen/blink.cmp",
		},
		opts = {
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
			},
		},
	},
	{
		"kevalin/mermaid.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("mermaid").setup()

			-- Install the Tree-sitter parser:
			-- :TSInstall mermaid
		end,
	},
}

return M
