local function get_root(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "gleam", {})
	local tree = parser:parse()[1]
	return tree:root()
end

local function move_cursor(closest_match)
	if not closest_match then
		return
	end

	local cursor_row, cursor_col = closest_match:start()

	-- The row is a line above the actual function definition
	vim.api.nvim_win_set_cursor(0, { cursor_row + 1, cursor_col })
end

local function move_up(query)
	local function_definitions = vim.treesitter.query.parse("gleam", query)

	local bufnr = vim.api.nvim_get_current_buf()
	local root = get_root(bufnr)

	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

	local closest_function = nil

	-- By starting at the row above the cursor it will make sure that the
	-- last capture is the closest function above.
	for _, fn in function_definitions:iter_captures(root, bufnr, 0, row - 1) do
		closest_function = fn
	end

	move_cursor(closest_function)
end

local function move_down(query)
	local function_definitions = vim.treesitter.query.parse("gleam", query)

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

local function goto_prev_function()
	move_up("(function (identifier) @function)")
end

local function goto_next_function()
	move_down("(function (identifier) @function)")
end

vim.keymap.set("n", "[f", goto_prev_function, { silent = true, noremap = true })
vim.keymap.set("n", "]f", goto_next_function, { silent = true, noremap = true })
