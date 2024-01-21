return {
  "f-person/git-blame.nvim",
  config = function ()
    require("gitblame").setup {
      vim.keymap.set("n", "<leader>bt", "<cmd>GitBlameToggle<CR>", { desc = "Toggle git blame" });
      vim.keymap.set("n", "<leader>boc", "<cmd>GitBlameOpenCommitURL<CR>", { desc = "Open the commit URL under the cursor" });
      vim.keymap.set("n", "<leader>bof", "<cmd>GitBlameOpenFileURL<CR>", { desc = "Open the file URL under the cursor" });
    }
  end

}
