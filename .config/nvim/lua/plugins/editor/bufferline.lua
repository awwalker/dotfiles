local lint_progress = function()
	local linters = require("lint").get_running()
	if #linters == 0 then
		return "󰦕"
	end
	return "󱉶 " .. table.concat(linters, ", ")
end

local M = {
	"akinsho/nvim-bufferline.lua",
	branch = "main",
	event = "BufEnter",
	opts = {
		options = {
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
			modifiedicon = "●",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(_, _, diagnostics_dict)
				local s = " "
				for e, n in pairs(diagnostics_dict) do
					local sym = e == "error" and " " or (e == "warning" and " " or "")
					s = s .. n .. sym
				end
				return s
			end,
			show_tab_indicators = true,
			sort_by = "tabs",
		},
	},
}

return M
