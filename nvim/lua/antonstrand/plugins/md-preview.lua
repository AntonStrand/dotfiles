return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    vim.keymap.set("n", "<leader>mps", ":MarkdownPreview<CR>", { desc = "Start markdown preview" })
    vim.keymap.set("n", "<leader>mpx", ":MarkdownPreviewStop<CR>", { desc = "Stop markdown preview" })
  end,
}
