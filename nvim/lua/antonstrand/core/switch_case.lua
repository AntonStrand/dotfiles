-- A set of functions to switch between different casings
-- Inspired by https://dev.to/dimaportenko/switching-between-camelcase-and-snakecase-in-neovim-using-lua-3ah7

local M = {}

M.to_camel_case = function(selection)
  local word = selection:gsub("([%w%d])[%s-]([%w%d])", "%1_%2"):gsub("(_)([a-z%d])", function(_, l)
    return l:upper()
  end)

  -- Make sure that the first char is lower case
  return word:sub(1, 1):lower() .. word:sub(2)
end

M.to_pascal_case = function(selection)
  local camel = M.to_camel_case(selection)
  return camel:sub(1, 1):upper() .. camel:sub(2)
end

M.to_snake_case = function(selection)
  return M.to_camel_case(selection):gsub("([a-z%d])([A-Z%d])", "%1_%2"):lower()
end

M.to_sentence_case = function(selection)
  return M.to_camel_case(selection):gsub("([a-z%d])([A-Z%d])", "%1 %2"):lower()
end

M.to_kebab_case = function(selection)
  return M.to_camel_case(selection):gsub("([a-z%d])([A-Z%d])", "%1-%2"):lower()
end

-- Sources
-- https://github.com/theHamsta/nvim-treesitter/blob/a5f2970d7af947c066fb65aef2220335008242b7/lua/nvim-treesitter/incremental_selection.lua#L22-L30
-- https://github.com/neovim/neovim/discussions/26092
local function visual_selection_range()
  -- If we don't change to normal mode the previous selection will be used.
  vim.cmd([[ execute "normal! \<ESC>" ]])
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local function set_text(line, start_pos, end_pos, text)
  vim.api.nvim_buf_set_text(0, line, start_pos, line, end_pos, { text })
end

local function transform(transformer)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "n" then
    local word = vim.fn.expand("<cword>")
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]
    local word_end = word_start + #word
    set_text(line - 1, word_start, word_end, transformer(word))
  elseif mode == "v" then
    local line, start_pos, _, end_pos = visual_selection_range()
    local selection = unpack(vim.api.nvim_buf_get_text(0, line, start_pos, line, end_pos, {}))
    set_text(line, start_pos, end_pos, transformer(selection))
  end
end

local function camel_case()
  transform(M.to_camel_case)
end

local function pascal_case()
  transform(M.to_pascal_case)
end

local function snake_case()
  transform(M.to_snake_case)
end

local function sentence_case()
  transform(M.to_sentence_case)
end

local function kebab_case()
  transform(M.to_kebab_case)
end

vim.api.nvim_create_user_command("ToCamelCase", camel_case, {})
vim.api.nvim_create_user_command("ToPascalCase", pascal_case, {})
vim.api.nvim_create_user_command("ToSnakeCase", snake_case, {})
vim.api.nvim_create_user_command("ToSentenceCase", sentence_case, {})
vim.api.nvim_create_user_command("ToKebabCase", kebab_case, {})

local dot_repeat = require("antonstrand.core.utils").dot_repeat
local modes = { "n", "v" }
local opts = { noremap = true, silent = true, expr = true }

opts.desc = "Convert to camelCase"
vim.keymap.set(modes, "<leader>tc", dot_repeat(camel_case), opts)

opts.desc = "Convert to PascalCase"
vim.keymap.set(modes, "<leader>tp", dot_repeat(pascal_case), opts)

opts.desc = "Convert to snake_case"
vim.keymap.set(modes, "<leader>ts", dot_repeat(snake_case), opts)

opts.desc = "Convert to sentence"
vim.keymap.set(modes, "<leader>tm", dot_repeat(sentence_case), opts)

opts.desc = "Convert to kebab-case"
vim.keymap.set(modes, "<leader>tk", dot_repeat(kebab_case), opts)

return M
