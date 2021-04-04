-- =============================
--             ICONS
-- =============================
require'nvim-web-devicons'.setup()
-- =============================
--          TREESITTER
-- =============================
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  rainbow = {
    enable = true;
  },
  highlight = {
    enable = true;
  },
  indent = {
    enable = true;
  },
}
-- =============================
--          STATUSLINE
-- =============================
require'eviline'
-- =============================
--          BUFFERLINE
-- =============================
require'bufferline'.setup {
  options = {
    view = 'multiwindow',
    modifiedicon = '●',
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
          or (e == "warning" and " " or "" )
        s = s .. n .. sym
      end
      return s
    end;
    mappings = true,
  }
}
