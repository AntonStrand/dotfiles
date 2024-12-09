vim.keymap.set("n", "<space><space>x", "<cmd>w<cr><cmd>source%<cr>", { desc = "Save and source file" })
vim.keymap.set("n", "<leader>x", ":.lua<cr>", { desc = "Run current line" })
vim.keymap.set("v", "<leader>x", ":lua<cr>", { desc = "Run current selection" })
