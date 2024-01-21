vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>sf', '/', { desc = "Search forwards" })
vim.keymap.set('n', '<leader>sb', '?', { desc = "Search backwards" })
vim.keymap.set('n', '<leader>sh', ':nohlsearch<CR>', { desc = "Hide search results" })

-- Move and center
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '}', '}zz')
vim.keymap.set('n', '{', '{zz')

-- Generate uuid
vim.keymap.set('n', '<leader>ug', ':!uuidgen | pbcopy<CR><CR>')
