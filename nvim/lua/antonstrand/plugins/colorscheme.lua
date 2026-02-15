return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      styles = {             -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
      },
    })

    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd([[colorscheme catppuccin]])
  end,
}
