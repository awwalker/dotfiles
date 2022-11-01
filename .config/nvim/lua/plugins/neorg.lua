-- =============================
--            NOTES
-- =============================
local neorg = require("neorg")

neorg.setup({
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/notes/work",
        },
      },
    },
    ["core.norg.concealer"] = {},
    ["core.norg.esupports.indent"] = {},
    ["core.norg.journal"] = {},
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
  },
})
