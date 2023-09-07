-- =============================
--          AUTOPAIRS
-- =============================

local autopairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")

autopairs.setup({ enable_check_bracket_line = false })
-- remove add single quote on filetype scheme or lisp
autopairs.get_rule("'")[1].not_filetypes = { "scheme", "lisp", "clojure" }
autopairs.get_rule("'")[1]:with_pair(cond.not_after_text("["))
