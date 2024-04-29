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
vim.keymap.set("n", "<leader>ug", ":!uuidgen | pbcopy<CR><CR>", { desc = "Generate UUID" })

-- Move selected lines with shift+j or shift+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Toggle boolean
vim.keymap.set("n", "<leader>tb", function()
	local line = vim.api.nvim_get_current_line()
	if line:match("true") then
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
