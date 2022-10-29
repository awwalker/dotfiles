local M = {}

M.efm = {
  {
    lintCommand = "misspell",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintSource = "misspell",
  },
}

M.all_format = {
  efm = "Misspell",
}

M.default_format = "efm"

return M
