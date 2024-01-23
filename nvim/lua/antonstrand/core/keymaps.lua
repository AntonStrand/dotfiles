vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>sh", ":nohlsearch<CR>", { desc = "Hide search results" })

-- Re-map common typo
vim.keymap.set("n", ":'", ":w", { desc = "Write file" })

-- Move and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- Generate uuid
vim.keymap.set("n", "<leader>ug", ":!uuidgen | pbcopy<CR><CR>")
