vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Use spaces instead of tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Enable copy/paste to clipboard
vim.cmd([[ set clipboard+=unnamedplus ]])