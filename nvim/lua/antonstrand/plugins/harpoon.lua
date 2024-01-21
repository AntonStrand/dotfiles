return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    -- set keymaps
    vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
    vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<leader>hj", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>hk", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>hl", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>hö", function() harpoon:list():select(4) end)

    vim.keymap.set("n", "<leader>hdj", function() harpoon:list():removeAt(1) end)
    vim.keymap.set("n", "<leader>hdk", function() harpoon:list():removeAt(2) end)
    vim.keymap.set("n", "<leader>hdl", function() harpoon:list():removeAt(3) end)
    vim.keymap.set("n", "<leader>hdö", function() harpoon:list():removeAt(4) end)
  end,
}
