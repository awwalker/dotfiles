local leap = require("leap")
leap.add_default_mappings()
-- leap.opts.max_highlighted_traversal_targets = 20
-- The below settings make Leap's highlighting a bit closer to what you've been
-- used to in Lightspeed.
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
vim.api.nvim_set_hl(0, "LeapMatch", {
  fg = "white", -- for light themes, set to 'black' or similar
  bold = true,
  nocombine = true,
})
leap.opts.highlight_unlabeled_phase_one_targets = true
