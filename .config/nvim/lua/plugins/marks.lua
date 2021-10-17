-- =============================
--            MARKS
-- =============================
require("marks").setup({
	mappings = {
		set_next = "m<space>",
		next = "m+",
		prev = "m-",
	},
	builtin_marks = { ".", "<", ">", "^" },
})
