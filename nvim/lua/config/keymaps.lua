vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>sh", ":nohlsearch<CR>", { desc = "Hide search highlight" })

-- Re-map common typo
vim.keymap.set("n", ":'", ":w", { desc = "Write file" })
vim.keymap.set("n", ":*", ":w", { desc = "Write file" })
vim.keymap.set("n", ':w"', ":wq", { desc = "Write and close all files" })

-- Move and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- Generate uuid
vim.keymap.set(
  "n",
  "<leader>ug",
  ":let @u = system(\"uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\\n'\")<CR>",
  { desc = "Generate UUID" }
)

-- Move selected lines with shift+j or shift+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move current line
vim.keymap.set("n", "<leader>j", ":m+1<CR>")
vim.keymap.set("n", "<leader>k", ":m-2<CR>")

vim.keymap.set("n", "<leader>n%", ":edit %:h<tab>", { desc = "Navigate to file directory" })
vim.cmd([[ cnoremap <expr>%% getcmdtype() == ':' ? expand('%:h') : '%%' ]])
