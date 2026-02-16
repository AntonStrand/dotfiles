local is_float_open = false

local opts = {
  keymaps = {
    close = {
      { mode = { "n", "v" }, key = "<esc>" },
      { mode = { "n", "v" }, key = "q" },
      { mode = { "n", "v" }, key = "k" },
    },
    close_in_float = {
      { mode = { "n" }, key = "<esc>" },
      { mode = { "n" }, key = "q" },
    },
    focus = {
      { mode = { "n", "v" }, key = "<cr>" },
      { mode = { "n" },      key = "j" },
    },
  },
}

local function del_keymaps(keymaps, bufnr)
  for _, map in ipairs(keymaps) do
    vim.keymap.del(map.mode, map.key, { buffer = bufnr })
  end
end

local function close_float(win)
  vim.api.nvim_win_close(win, true)
  is_float_open = false
end

local function focus_float(bufnr, win)
  return function()
    -- Enable keys to act as usual again
    del_keymaps(opts.keymaps.close, 0)
    del_keymaps(opts.keymaps.focus, 0)

    vim.api.nvim_set_current_win(win)

    local function close()
      del_keymaps(opts.keymaps.close_in_float, bufnr)
      close_float(win)
    end

    for _, map in ipairs(opts.keymaps.close_in_float) do
      vim.keymap.set(map.mode, map.key, close, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = "Close the float",
      })
    end
  end
end

local function add_keymaps(float_bufnr, window)
  local keymap_opts = {
    buffer = 0,
    noremap = true,
    silent = true,
  }

  local function close()
    -- Enable key to act as usual again
    del_keymaps(opts.keymaps.close, 0)
    del_keymaps(opts.keymaps.focus, 0)
    close_float(window)
  end

  keymap_opts.desc = "Close the float"
  for _, map in ipairs(opts.keymaps.close) do
    vim.keymap.set(map.mode, map.key, close, keymap_opts)
  end

  keymap_opts.desc = "Focus the float"
  for _, map in ipairs(opts.keymaps.focus) do
    vim.keymap.set(map.mode, map.key, focus_float(float_bufnr, window), keymap_opts)
  end
end

local function fetch_definition()
  local word = vim.fn.expand("<cword>")

  local response = vim.system({ "curl", "https://api.dictionaryapi.dev/api/v2/entries/en/" .. word }, { text = true })
      :wait()

  local body = vim.json.decode(response.stdout)

  if body.title == "No Definitions Found" then
    print("No definition found for " .. word)
    return nil
  else
    return body
  end
end

local function open_float(title, content)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, content)

  local row = vim.api.nvim_win_get_height(0)

  local window = vim.api.nvim_open_win(bufnr, false, {
    title = title,
    relative = "win",
    border = "rounded",
    anchor = "SW",
    width = vim.api.nvim_win_get_width(0),
    height = #content + 2,
    row = row,
    col = 0,
    style = "minimal",
  })

  add_keymaps(bufnr, window)
  is_float_open = true
end

local function define_word()
  if is_float_open then
    return
  end

  local body = fetch_definition()

  if body ~= nil then
    local best_match = body[1]
    local definitions = best_match.meanings[1].definitions
    local content = {} --{ " Definition of " .. best_match.word .. " ", "" }
    for index, definition in ipairs(definitions) do
      content[index] = " " .. index .. ". " .. definition.definition
    end

    local title = " Definition of " .. best_match.word .. " "
    open_float(title, content)
  end
end

local function find_synonyms()
  if is_float_open then
    return
  end

  local body = fetch_definition()

  if body ~= nil then
    local best_match = body[1]
    local content = {}
    local index = 1

    for _, meaning in ipairs(best_match.meanings) do
      for _, synonym in ipairs(meaning.synonyms) do
        content[index] = " " .. index .. ". " .. synonym
        index = index + 1
      end
    end

    if #content == 0 then
      print("No synonyms found for " .. best_match.word)
    else
      local title = " Synonyms of " .. best_match.word .. " "
      open_float(title, content)
    end
  end
end

vim.keymap.set("n", "<leader>vd", define_word, { desc = "[v]iew [d]efinition of current word" })
vim.keymap.set("n", "<leader>vs", find_synonyms, { desc = "[v]iew [s]ynonyms of current word" })
