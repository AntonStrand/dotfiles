-- Description: Toggle boolean values in the current line or at the cursor.

local function replace_word(new_word)
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]
  local word_end = word_start + #vim.fn.expand("<cword>")
  vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_end, { new_word })
end

local function toogle_boolean()
  local line = vim.api.nvim_get_current_line()
  local word = vim.fn.expand("<cword>")

  if word == "true" then
    replace_word("false")
  elseif word == "false" then
    replace_word("true")
    -- Also support Elm's True and False
  elseif word == "True" then
    replace_word("False")
  elseif word == "False" then
    replace_word("True")

    -- Replace all occurrences of true and false on a line
  elseif line:match("true") then
    local new_line = line:gsub("true", "false")
    vim.api.nvim_set_current_line(new_line)
  elseif line:match("false") then
    local new_line = line:gsub("false", "true")
    vim.api.nvim_set_current_line(new_line)

    -- Also support Elm's True and False
  elseif line:match("True") then
    local new_line = line:gsub("False", "False")
    vim.api.nvim_set_current_line(new_line)
  elseif line:match("False") then
    local new_line = line:gsub("False", "True")
    vim.api.nvim_set_current_line(new_line)
  end
end

vim.keymap.set("n", "<leader>tb", toogle_boolean, { desc = "Toggle boolean" })
