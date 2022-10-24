-- =============================
--            MARKS
-- =============================
require("marks").setup({
  mappings = {
    set_next = "mm",
    next = "m[",
    prev = "m]",
  },
  builtin_marks = { ".", "<", ">", "^" },
})
