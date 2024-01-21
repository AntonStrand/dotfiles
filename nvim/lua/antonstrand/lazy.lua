local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "antonstrand.plugins"},
  { import = "antonstrand.plugins.lsp" }
}, {
  install = {
    colorscheme = { "catppuccin" },  -- Use colorscheme for new plugins
  },
  -- Check for updates but don't notify
  checker = {
    enabled = true,
    notify = false,
  },
  -- Don't notify when config files has been changed
  change_detection = {
    notify = false,
  }
})
