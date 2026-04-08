-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		require("catppuccin").setup()
-- 		vim.cmd.colorscheme("catppuccin-mocha")
-- 	end,
-- }
return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("rose-pine-moon")
	end,
}
