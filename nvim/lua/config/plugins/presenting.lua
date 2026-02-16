return {
	"sotte/presenting.nvim",
	opts = {
		-- fill in your options here
		-- see :help Presenting.config
		options = {
			-- The width of the slide buffer.
			width = 80,
		},
		separator = {
			-- Separators for different filetypes.
			-- You can add your own or oberwrite existing ones.
			-- Note: separators are lua patterns, not regexes.
			markdown = "^# ",
			org = "^*+ ",
			adoc = "^==+ ",
			asciidoctor = "^==+ ",
		},
		-- Keep the separator, useful if you're parsing based on headings.
		-- If you want to parse on a non-heading separator, e.g. `---` set this to false.
		keep_separator = true,
	},
	cmd = { "Presenting" },
}
