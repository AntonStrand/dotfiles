-- diagnostic display settings
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = "󰅚 ",
      [severity.WARN] = "󰀪 ",
      [severity.HINT] = "󰌶 ",
      [severity.INFO] = "󰋽 ",
    },
  },
  virtual_text = {
    spacing = 2,
    format = function(diagnostic)
      -- Don't show any message for info or hint
      if diagnostic.severity == severity.INFO or diagnostic.severity == severity.HINT then
        return ""
      end

      -- Only show a short message for warnings and errors
      local first_line = diagnostic.message:gmatch("[^\n]*")()
      local first_sentence = string.match(first_line, "(.-%. )") or first_line
      local first_lhs = string.match(first_sentence, "(.-): ") or first_sentence
      return first_lhs
    end,
  },
})

-- diagnostic keymaps
local diagnostic_goto = function(next, severity_)
  severity_ = severity_ and severity[severity_] or nil
  return function()
    vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity_ })
  end
end

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, severity.ERROR), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, severity.ERROR), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, severity.WARN), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, severity.WARN), { desc = "Prev Warning" })
