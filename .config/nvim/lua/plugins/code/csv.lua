local M = {
	{
		"cameron-wags/rainbow_csv.nvim",
		-- Latest tag (4.3.0, 2019) is ~125 commits behind the default branch.
		version = false,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},
	{
		"chrisbra/csv.vim",
		event = { "BufRead", "BufWritePre", "BufReadPre", "InsertEnter" },
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
	},
}

return M
