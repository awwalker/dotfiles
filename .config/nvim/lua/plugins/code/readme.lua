local M = {
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	{
		"vinnymeller/swagger-preview.nvim",
		cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
		build = "npm i",
		config = true,
	},
}

return M
