local ultest = require("ultest")
local utils = require("core.utils")

-- TODO move these to settings.
-- vim.fn [[ test#python#pytest#options --color=yes]]
-- vim.fn [[ test#go#gotest#options --color=yes ]]
local function gotest_argparse(cmd)
	-- Takes in a cmd in the form of:
	-- { 'go', 'test', '-run', 'TestName', './test/package/' }
	-- and turns it into a table of { '-test.run', 'TestName' }
	local args = {}
	for i = 3, #cmd - 1, 1 do
		local arg = cmd[i]
		if vim.startswith(arg, "-") then
			-- Delve requires test flags be prefix with 'test.'
			arg = "-test." .. string.sub(arg, 2)
		end
		args[#args + 1] = arg
	end
	print(utils.debug_print(args))
	return args
end

ultest.setup({
	builders = {
		["go#gotest"] = function(cmd)
			local args = gotest_argparse(cmd)
			return {
				dap = {
					type = "go",
					request = "launch",
					mode = "test",
					dlvToolPath = vim.fn.exepath("dlv"),
					args = args,
				},
				parse_result = function(lines)
					return lines[#lines] == "FAIL" and 1 or 0
				end,
			}
		end,
	},
})
