return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline" },
  keys = {
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    keymaps = {
      up_and_jump = "<C-p>",
      down_and_jump = "<C-n>",
    },
    outline_items = {
      show_symbol_lineno = true,
    },
  },
}
