local o = vim.opt

-- Performance settings
o.synmaxcol = 300  -- Syntax highlighting limit
o.updatetime = 300 -- Faster completion
o.redrawtime = 10000
o.maxmempattern = 20000

o.backspace = "2"
o.showcmd = true
o.laststatus = 2
o.autowrite = true
o.cursorline = true
o.autoread = true

-- Line numbers
o.number = true -- Show line number of the current line
o.relativenumber = true

-- Use spaces instead of tabs
o.tabstop = 2
o.shiftwidth = 2
o.shiftround = true
o.expandtab = true

-- Enable ignorecase + smartcase for better searching
o.ignorecase = true
o.smartcase = true

-- Set completeopt to have a better completion experience
o.completeopt = { "menuone", "noselect" }

-- Enable persistent undo history
o.undofile = true

-- Don't create swap files
o.swapfile = false

-- Enable 24-bit color
o.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
o.signcolumn = "yes"

-- Always keep 8 lines above/below cursor unless at start/end of file
o.scrolloff = 8

-- Always keep cursor 8 characters from horizontal edge unless at start/end of file
o.sidescrolloff = 8

-- O and o, don't continue comments
vim.cmd([[autocmd FileType * set formatoptions-=o]])

-- Set spell languanges but spell is opt in.
o.spelllang = "sv,en_us"

-- Preview commands in a separate window
o.inccommand = "split"

-- Use ripgrep for grep
vim.cmd([[set grepprg=rg\ --vimgrep\ --smart-case\ --follow]])

-- Rounded bordes collides with Wilder styling while suggesting commands
-- This is a workaround by removing the boarded when using the command
local boarder = "rounded"
o.winborder = boarder

vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    o.winborder = "none"
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    o.winborder = boarder
  end,
})

-- Tell nvim how to handle modern filetypes
vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})
