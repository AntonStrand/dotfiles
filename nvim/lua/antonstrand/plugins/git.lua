return {
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		config = function()
			require("gitblame").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup()
		end,
	},
}
