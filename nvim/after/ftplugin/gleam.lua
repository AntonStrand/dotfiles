local function find_parent(types, node)
	if not node then
		return nil
	end

	if vim.tbl_contains(types, node:type()) then
		return node
	end

	local next_node = node:parent()

	if not next_node then
		next_node = node:next_sibling()
		return nil
	end

	return find_parent(types, next_node)
end

local function find_child(types, node)
	if not node then
		return nil
	end

	if vim.tbl_contains(types, node:type()) then
		return node
	end

	local next_node = node:child()

	return find_child(types, next_node)
end

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

local function around_function()
	local current_node = vim.treesitter.get_node()
	local parent = find_parent({ "function", "anonymous_function" }, current_node)

	if not parent then
		print("No parent found")
		return
	end

	local srow, scol, erow, ecol = parent:range()

	vim.cmd([[ execute "normal! \<ESC>" ]]) -- Delete if there is anything in the command line already
	vim.cmd("normal! " .. srow + 1 .. "G" .. scol .. "|") -- go to the first row and columns of the function
	vim.cmd("normal! v" .. erow + 1 .. "G" .. ecol .. "|") -- visual select to last row and column
end

local function inner_function()
	local function_body = { "function_body" }
	local current_node = vim.treesitter.get_node()
	local node = nil

	if current_node then
		if vim.tbl_contains({ "function" }, current_node:type()) then
			node = find_child(function_body, current_node)
		else
			node = find_parent(function_body, current_node)
		end
	end

	if not node then
		return
	end

	local srow, scol, erow, ecol = node:range()

	local row_span = erow - srow

	vim.cmd([[ execute "normal! \<ESC>" ]]) -- Delete if there is anything in the command line already
	vim.cmd("normal! " .. srow + 1 .. "G" .. scol .. "|") -- go to the first row and columns of the function
	vim.cmd("normal! v" .. erow + 1 .. "G" .. ecol .. "|") -- visual select to last row and column
end

vim.keymap.set("n", "[f", goto_prev_function, { silent = true, noremap = true })
vim.keymap.set("n", "]f", goto_next_function, { silent = true, noremap = true })
vim.keymap.set("o", "af", around_function, { silent = true, noremap = true })
vim.keymap.set("x", "af", around_function, { silent = true, noremap = true })
vim.keymap.set("o", "if", inner_function, { silent = true, noremap = true })
vim.keymap.set("x", "if", inner_function, { silent = true, noremap = true })
