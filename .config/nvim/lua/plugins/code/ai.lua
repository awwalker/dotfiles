local M = {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub",
		-- Installs `mcp-hub` node binary globally.
		build = "npm install -g mcp-hub@4.2.0",
		config = function()
			require("mcphub").setup()
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		version = "^18.3.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
			"lalitmee/codecompanion-spinners.nvim",
		},
		cmd = { "CodeCompanionChat", "CodeCompanion" },
		config = function()
			require("codecompanion").setup({
				opts = {
					log_level = "DEBUG",
					cmd = {
						timeout = 100000,
					},
				},
				strategies = {
					chat = {
						adapter = {
							name = "claude_code",
							model = "opus",
						},
					},
				},
				interactions = {
					chat = {
						slash_commands = {
							["file"] = {
								-- Use Telescope as the provider for the /file command
								opts = {
									provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
								},
							},
						},
						adapter = {
							name = "claude_code",
							model = "opus",
						},
					},
				},
				adapters = {
					acp = {
						claude_code = function()
							local key = "cmd:op read op://employee/aaron-anthropic-key/password --no-newline"
							return require("codecompanion.adapters").extend("claude_code", {
								env = {
									api_key = key,
									ANTHROPIC_API_KEY = key,
								},
								defaults = {
									timeout = 30000,
								},
							})
						end,
					},
					http = {
						anthropic = function()
							local key = "cmd:op read op://employee/aaron-anthropic-key/password --no-newline"
							return require("codecompanion.adapters").extend("anthropic", {
								env = {
									api_key = key,
									ANTHROPIC_API_KEY = key,
								},
								defaults = {
									timeout = 30000,
								},
							})
						end,
					},
				},
				extensions = {
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							make_vars = true,
							make_slash_commands = true,
							show_result_in_chat = true,
						},
					},
					spinner = {
						style = "lualine",
					},
				},
			})
		end,
	},
}

return M
