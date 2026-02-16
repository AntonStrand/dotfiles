local function jump_to(direction)
  return function()
    local trouble = require("trouble")
    trouble.jump_only(trouble[direction]({}, {}), { jump = true })
  end
end

local opts = { silent = true, noremap = true }

opts.desc = "jump to next trouble"
vim.keymap.set("n", "]x", jump_to("next"), opts)

opts.desc = "jump to previous trouble"
vim.keymap.set("n", "[x", jump_to("prev"), opts)

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  cmd = "Trouble",
  keys = {
    {
      "<leader>xb",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xe",
      "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
      desc = "Diagnostics erros (Trouble)",
    },
  },
}
