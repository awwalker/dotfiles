local M = {
	{
		"georgeharker/sharedserver",
		build = "cargo install --path rust",
		lazy = false,
	},

	-- mcp-companion: the bridge + Neovim plugin
	{
		"georgeharker/mcp-companion",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"olimorris/codecompanion.nvim",
		},
		build = "cd bridge && uv sync --frozen",
		config = function()
			require("mcp_companion").setup({
				bridge = {
					port = 9741,
					config = vim.fn.expand("~/.config/mcp/servers.json"),
				},
				log = { level = "info", notify = "error" },
			})
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"lalitmee/codecompanion-spinners.nvim",
		},
		cmd = { "CodeCompanionChat", "CodeCompanion", "CodeCompanionCLI" },
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
									provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
								},
							},
						},
						adapter = {
							name = "claude_code",
							model = "opus",
						},
					},
					cli = {
						agent = "claude_code",
						agents = {
							claude_code = {
								cmd = "claude",
								args = {},
								description = "Claude Code CLI",
								provider = "terminal",
							},
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
									model = "opus",
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
					mcp_companion = {
						callback = "mcp_companion.cc",
						opts = {},
					},
					spinner = {
						opts = {
							style = "lualine",
						},
					},
				},
			})
		end,
		init = function()
			local function ghostty_notify(title, body)
				-- Send OSC 9 escape sequence for Ghostty notification
				-- Format: \033]9;title;body\007
				local notification = string.format("\027]9;%s;%s\007", title, body or "")
				io.write(notification)
				io.flush()
			end
			local last_autocmd = {}

			-- Helper to debounce notifications
			local function should_notify(event_name)
				local cur = os.time()
				if not last_autocmd[event_name] or cur - last_autocmd[event_name] > 2 then
					last_autocmd[event_name] = cur
					return true
				end
				return false
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = { "CodeCompanionChatDone", "CodeCompanionRequestFinished", "CodeCompanionToolApprovalRequested" },
				callback = function(args)
					if should_notify(args.match) then
						if args.match == "CodeCompanionChatDone" then
							ghostty_notify("CodeCompanion", "Chat is ready for interaction")
						elseif args.match == "CodeCompanionRequestFinished" then
							ghostty_notify("CodeCompanion", "LLM has generated a response")
						elseif args.match == "CodeCompanionToolApprovalRequested" then
							local tool_name = args.data.tool.name or "Tool"
							ghostty_notify("CodeCompanion", "Waiting for approval: " .. tool_name)
						end
					end
				end,
			})
		end,
	},
}

return M
