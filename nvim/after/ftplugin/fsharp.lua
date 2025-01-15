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
		print("try sibling" .. vim.inspect(next_node))
		return nil
	end

	return find_parent(types, next_node)
end

local function get_root(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "fsharp", {})
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
end

local function move_up(query)
	local function_definitions = vim.treesitter.query.parse("fsharp", query)

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
	local function_definitions = vim.treesitter.query.parse("fsharp", query)

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

local function goto_parent_function()
	move_up("(function_declaration_left) @function (function_expression) @function (fun_expression) @function")
end

local function goto_next_top_function()
	move_up("(function_declaration_left) @function")
end

local function goto_next_function()
	move_down("(function_declaration_left) @function (function_expression) @function (fun_expression) @function")
end

local function goto_next_bottom_function()
	move_down("(function_declaration_left) @function")
end

local function goto_prev_match()
	move_up(
		"(match_expression (rules (rule (identifier_pattern (long_identifier_or_op) @match) ))) (match_expression (rules (rule (const) @match)))"
	)
end

local function goto_next_match()
	move_down(
		"(match_expression (rules (rule (identifier_pattern (long_identifier_or_op) @match) ))) (match_expression (rules (rule (const) @match)))"
	)
end

-- local function outer_function()
-- 	local query = "(declaration_expression (function_or_value_defn (declaration_expression) @dec))"
-- end

local function outer_function()
	local current_node = vim.treesitter.get_node()
	local parent = find_parent({ "declaration_expression" }, current_node)
	if not parent then
		print("No parent found")
		return
	end
	local srow, scol, erow, ecol = parent:range()

	local row_span = erow - srow

	vim.cmd([[ execute "normal! \<ESC>" ]]) -- Delete if there is anything in the command line already
	vim.cmd(tostring(srow + 1)) -- go to the first row of the function
	vim.cmd("normal! V" .. row_span .. "j") -- visual select from first row to the last

	print(vim.inspect(parent:named()), vim.inspect(srow), vim.inspect(scol), vim.inspect(erow), vim.inspect(ecol))
end

vim.keymap.set("n", "[f", goto_parent_function, { silent = true, noremap = true })
vim.keymap.set("n", "]f", goto_next_function, { silent = true, noremap = true })
vim.keymap.set("n", "[F", goto_next_top_function, { silent = true, noremap = true })
vim.keymap.set("n", "]F", goto_next_bottom_function, { silent = true, noremap = true })
vim.keymap.set("o", "af", outer_function, { silent = true, noremap = true })
vim.keymap.set("x", "af", outer_function, { silent = true, noremap = true })
-- vim.keymap.set("n", "[m", goto_prev_match, { silent = true, noremap = true })
-- vim.keymap.set("n", "]m", goto_next_match, { silent = true, noremap = true })
