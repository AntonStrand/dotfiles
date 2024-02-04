return {
  "stevearc/oil.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({})
    vim.keymap.set("n", "<leader>e", require("oil").toggle_float, { desc = "Open [e]xplorer popup" })
  end,
}
