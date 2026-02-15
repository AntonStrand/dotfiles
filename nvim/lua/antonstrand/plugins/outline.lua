return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline" },
	keys = {
	},
	opts = {},
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  opts = {
    outline_items = {
      show_symbol_lineno = true,
    },
  },
}
