require("toggleterm").setup({
	open_mapping = [[<c-t>]],
	close_on_exit = true,
	size = function(term)
		if term.direction == "horizontal" then
			return vim.o.lines * 0.25
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	start_in_insert = false,
})
