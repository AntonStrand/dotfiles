local function toggle_md_checkbox()
  -- Get current position.
  local original_line, original_col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Make sure to move to the inside of the checkbox no matter where on the line the cursor is.
  vim.cmd("norm! 0f[l")

  -- Get the current character in the checkbox.
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local mark = vim.api.nvim_get_current_line():sub(col + 1, col + 1)

  -- Toggle based on the character.
  if mark == " " then
    mark = "x"
  else
    mark = " "
  end

  vim.cmd("norm! r" .. mark)

  -- Move cursor back to the original position.
  vim.api.nvim_win_set_cursor(0, { original_line, original_col })
end

vim.keymap.set("n", "<leader>mc", toggle_md_checkbox, { desc = "Toggle markdown checkbox" })
