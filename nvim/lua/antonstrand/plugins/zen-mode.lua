local zen_mode = require("zen-mode")

vim.keymap.set("n", "<leader>z", zen_mode.toggle, { noremap = true, silent = true, desc = "Toggle Zen Mode" })

return { "folke/zen-mode.nvim" }
