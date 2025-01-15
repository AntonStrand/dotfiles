vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- Line numbers
vim.opt.number = true -- Show line number of the current line
vim.opt.relativenumber = true

-- Use spaces instead of tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menuone", "noselect" }

-- Enable persistent undo history
vim.opt.undofile = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Always keep cursor 8 characters from horizontal edge unless at start/end of file
vim.opt.sidescrolloff = 8

-- O and o, don't continue comments
vim.cmd([[autocmd FileType * set formatoptions-=o]])

-- Set spell languanges but spell is opt in.
vim.opt.spelllang = "sv,en_us"

-- Enable copy/paste to clipboard
-- vim.cmd([[ set clipboard+=unnamedplus ]])
