-- A set of functions to switch between different casings
-- Inspired by https://dev.to/dimaportenko/switching-between-camelcase-and-snakecase-in-neovim-using-lua-3ah7

local function replace_word(new_word)
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]
	local word_end = word_start + #vim.fn.expand("<cword>")
	vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_end, { new_word })
end

local function snake_case_to_camel(word)
	return word:gsub("(_)([a-z])", function(_, l)
		return l:upper()
	end)
end

-- Can convert both Pascal and camelCase to snake_case
local function to_snake_case(word)
	return word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
end

local function to_sentence_case(word)
	return word:gsub("([a-z])([A-Z])", "%1 %2"):lower()
end

local function first_upper(word)
	return word:sub(1, 1):upper() .. word:sub(2)
end

local function is_camel_case(word)
	return word:find("[a-z][A-Z]")
end

local function is_pascal_case(word)
	return word:find("^[A-Z]")
end

local function is_snake_case(word)
	return word:find("_[a-z]")
end

local function camel_case()
	local word = vim.fn.expand("<cword>")

	if is_pascal_case(word) then
		-- Convert PascalCase to camelCase
		local camel_case_word = word:sub(1, 1):lower() .. word:sub(2)
		replace_word(camel_case_word)
	elseif is_snake_case(word) then
		replace_word(snake_case_to_camel(word))
	else
		print("Unable to convert to camelCase")
	end
end

local function pascal_case()
	local word = vim.fn.expand("<cword>")

	if is_camel_case(word) then
		replace_word(first_upper(word))
	elseif is_snake_case(word) then
		local camel_case_word = snake_case_to_camel(word)
		replace_word(first_upper(camel_case_word))
	else
		print("Unable to convert to PascalCase")
	end
end

local function snake_case()
	local word = vim.fn.expand("<cword>")

	if is_camel_case(word) or is_pascal_case(word) then
		replace_word(to_snake_case(word))
	else
		print("Unable to convert to snake_case")
	end
end

local function sentence_case()
	local word = vim.fn.expand("<cword>")

	if is_camel_case(word) or is_pascal_case(word) then
		replace_word(to_sentence_case(word))
	elseif is_snake_case(word) then
		replace_word(to_sentence_case(snake_case_to_camel(word)))
	else
		print("Unable to convert to sentence")
	end
end

vim.api.nvim_create_user_command("ToCamelCase", camel_case, {})
vim.api.nvim_create_user_command("ToPascalCase", pascal_case, {})
vim.api.nvim_create_user_command("ToSnakeCase", snake_case, {})
vim.api.nvim_create_user_command("ToSentenceCase", sentence_case, {})

vim.keymap.set("n", "<leader>tc", camel_case, { noremap = true, silent = true, desc = "Convert to camelCase" })
vim.keymap.set("n", "<leader>tp", pascal_case, { noremap = true, silent = true, desc = "Convert to PascalCase" })
vim.keymap.set("n", "<leader>ts", snake_case, { noremap = true, silent = true, desc = "Convert to snake_case" })
vim.keymap.set("n", "<leader>tm", sentence_case, { noremap = true, silent = true, desc = "Convert to sentence" })
