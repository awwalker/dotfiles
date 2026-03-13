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
			local mcphub = require("mcphub")

			mcphub.setup({})
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
									provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
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
