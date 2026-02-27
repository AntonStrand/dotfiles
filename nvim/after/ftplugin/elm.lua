local function get_root(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "elm", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local function move_cursor(closest_match)
  if not closest_match then
    return
  end

  local _, col = unpack(vim.api.nvim_win_get_cursor(0))

  local cursor_row, cursor_col = closest_match:start()

  if closest_match:type() == "function_declaration_left" then
    local line_width = #vim.api.nvim_get_current_line()

    if line_width > col then
      cursor_col = col
    else
      cursor_col = 0
    end
  end

  -- The row is a line above the actual function definition
  vim.api.nvim_win_set_cursor(0, { cursor_row + 1, cursor_col })
  vim.cmd("normal! m'")
end

local function move_up(query)
  local definition_query = vim.treesitter.query.parse("elm", query)

  local bufnr = vim.api.nvim_get_current_buf()
  local root = get_root(bufnr)

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  local closest_match = nil

  -- By starting at the row above the cursor it will make sure that the
  -- last capture is the closest function above.
  for _, fn in definition_query:iter_captures(root, bufnr, 0, row - 1) do
    closest_match = fn
  end

  print(row, closest_match, vim.inspect(closest_match))

  move_cursor(closest_match)
end

local function move_down(query)
  local function_definitions = vim.treesitter.query.parse("elm", query)

  local bufnr = vim.api.nvim_get_current_buf()
  local root = get_root(bufnr)

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  local closest_function = nil

  -- By starting at the row above the cursor it will make sure that the
  -- last capture is the closest function above.
  for _, fn in function_definitions:iter_captures(root, bufnr, row + 1, -1) do
    local s_row, _, e_row, _ = fn:range()

    if not closest_function and s_row > row then
      closest_function = fn
    end
  end

  move_cursor(closest_function)
end

local function get_match_range(query_string)
  local query = vim.treesitter.query.parse("elm", query_string)

  local bufnr = vim.api.nvim_get_current_buf()
  local root = get_root(bufnr)

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  local start_row = 0
  local end_row = vim.api.nvim_buf_line_count(bufnr)
  local start_col = nil
  local end_col = nil

  -- By starting at the row above the cursor it will make sure that the
  -- last capture is the closest function above.
  for _, match in query:iter_captures(root, bufnr) do
    local s_row, s_col, e_row, e_col = match:range()
    local offset_e = e_row + 1

    -- print(row, s_row, e_row)
    if row >= s_row and row <= offset_e then
      start_row = vim.fn.max({ start_row, s_row })
      end_row = vim.fn.min({ end_row, offset_e })
      if start_row == s_row and end_row == offset_e then
        start_col = s_col
        end_col = e_col
      end
    end
  end
  return start_row, start_col, end_row, end_col
end

local function to_previous_function()
  move_up("(function_declaration_left) @function")
end

local function to_next_function()
  move_down("(function_declaration_left) @function")
end

local function to_previous_top_function()
  move_up("(file (value_declaration (function_declaration_left) @top_function)) ")
end

local function to_next_top_function()
  move_down("(file (value_declaration (function_declaration_left) @top_function)) ")
end

local function to_previous_type_annotation()
  move_up("(type_annotation) @type_annotation")
end

local function to_next_type_annotation()
  move_down("(type_annotation) @type_annotation")
end

local function select(s_row, s_col, e_row, e_col)
  if s_row == nil or s_col == nil or e_row == nil or e_col == nil then
    return
  end

  vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
  vim.cmd("normal! m<")

  vim.api.nvim_win_set_cursor(0, { e_row, e_col })
  vim.cmd("normal! m>")

  vim.cmd("normal! gv")
end

local function inner_function()
  local s_row, s_col, e_row, e_col = get_match_range("(value_declaration body: (_) @body)")
  select(s_row, s_col, e_row, e_col)
end

local function around_function()
  local s_row, s_col, e_row, e_col = get_match_range("(value_declaration body: (_) @body)")
  select(s_row - 1, e_row + 1)
end

vim.keymap.set({ "o", "x" }, "if", inner_function, { silent = true, noremap = true })
vim.keymap.set({ "o", "x" }, "af", around_function, { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "[f", to_previous_function, { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "]f", to_next_function, { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "[F", to_previous_top_function, { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "]F", to_next_top_function, { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "[t", to_previous_type_annotation, { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "]t", to_next_type_annotation, { silent = true, noremap = true })
