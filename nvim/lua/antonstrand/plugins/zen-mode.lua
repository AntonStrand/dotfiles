local total_zen = function()
  require("twilight").toggle()
	require("zen-mode").toggle()
end
vim.keymap.set("n", "<leader>z", total_zen, { noremap = true, silent = true, desc = "Toggle Zen Mode" })

return {
	"folke/zen-mode.nvim",
	"folke/twilight.nvim",
}
