local gl = require('galaxyline')
local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')
local utils = require('utils')
local gls = gl.section

gls.left[1] = {
  RainbowRed = {
    provider = function() return '▊ ' end,
    highlight = { colors.blue, colors.bg }
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      -- Auto change color according the mode.
      local mode_color = {
        i = colors.green, ic = colors.yellow,
        v = colors.blue, V = colors.blue, Vi = colors.blue, [utils.t'<C-v>'] = colors.blue,
        n = colors.red, no = colors.red, nvo = colors.blue,
        S = colors.orange, s = colors.orange,
        R = colors.violet, Rv = colors.violet,
        c = colors.magenta, cv = colors.red, ce=colors.red,
        r = colors.cyan, rm = colors.cyan, ['r?'] = colors.cyan,
        ['!']  = colors.red, t = colors.red,
      }
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' ..colors.bg)
      return '  '
    end,
  },
}
gls.left[3] = {
  FileSize = {
    provider = 'FileSize',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.bg}
  }
}
gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
  },
}

gls.left[5] = {
  FileName = {
    provider = function()
      return vim.fn.expand("%:F")
    end,
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, 'bold' }
  }
}

gls.left[6] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.fg, colors.bg },
  },
}

gls.left[7] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = { 'NONE',colors.bg },
    highlight = { colors.fg, colors.bg, 'bold' },
  }
}

gls.left[8] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = { colors.red, colors.bg }
  }
}
gls.left[9] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = { colors.yellow, colors.bg },
  }
}

gls.left[10] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = { colors.cyan, colors.bg },
  }
}

gls.left[11] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = { colors.blue, colors.bg },
  }
}

gls.right[1] = {
  FileEncode = {
    provider = 'FileEncode',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.green, colors.bg, 'bold' },
  }
}

gls.right[2] = {
  FileFormat = {
    provider = 'FileFormat',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.green, colors.bg, 'bold' },
  }
}

gls.right[3] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.violet, colors.bg, 'bold' },
  }
}

gls.right[4] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = { colors.violet, colors.bg, 'bold' },
  }
}

gls.right[5] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = { colors.green, colors.bg },
  }
}
gls.right[6] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = { colors.orange, colors.bg },
  }
}
gls.right[7] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = { colors.red, colors.bg },
  }
}

gls.right[8] = {
  RainbowBlue = {
    provider = function() return ' ▊' end,
    highlight = { colors.blue, colors.bg },
  },
}

gl.load_galaxyline()
