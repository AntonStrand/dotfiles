vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>sh", ":nohlsearch<CR>", { desc = "Hide search results" })

-- Re-map common typo
vim.keymap.set("n", ":'", ":w", { desc = "Write file" })

-- Move and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- Generate uuid
vim.keymap.set(
	"n",
	"<leader>ug",
	":let @u = system(\"uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\\n'\")<CR>",
	{ desc = "Generate UUID" }
)

-- Move selected lines with shift+j or shift+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

local function replace_word(new_word)
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]
	local word_end = word_start + #vim.fn.expand("<cword>")
	vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_end, { new_word })
end

-- Toggle boolean
vim.keymap.set("n", "<leader>tb", function()
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
		local new_line = line:gsub("True", "False")
		vim.api.nvim_set_current_line(new_line)
	elseif line:match("False") then
		local new_line = line:gsub("False", "True")
		vim.api.nvim_set_current_line(new_line)
	end
end, { desc = "Toggle boolean" })
