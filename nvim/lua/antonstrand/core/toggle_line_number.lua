local is_relative = true

local function toggle_relative_number()
	vim.opt.relativenumber = is_relative
	is_relative = not is_relative
end

vim.keymap.set("n", "<leader>tn", toggle_relative_number, { noremap = true, silent = true })
