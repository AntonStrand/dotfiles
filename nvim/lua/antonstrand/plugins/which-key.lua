return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    plugins = { spelling = true },
    defaults = {
      ["gc"] = { name = "+Comment" },
      ["<leader>e"] = { name = "+Explorer" },
      ["<leader>f"] = { name = "+Find" },
      ["<leader>s"] = { name = "+Search" },
      ["<leader>n"] = { name = "+Next" },
      ["<leader>p"] = { name = "+Prev" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
