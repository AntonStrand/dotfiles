local oil = require("oil")

local function copy(path)
	local cmd = string.format([[osascript -e 'set the clipboard to POSIX file "%s"' ]], path)
	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Copy failed: " .. result, vim.log.levels.ERROR)
	else
		vim.notify("Copied to system clipboard", vim.log.levels.INFO)
	end
end

local function yank_entry(entry)
	local path = oil.get_current_dir(0)

	if path and entry then
		-- Escape the path for shell command
		copy(vim.fn.fnameescape(path .. entry.parsed_name))
	else
		vim.notify("No file or directory selected", vim.log.levels.WARN)
	end
end

local function zip_and_yank()
	local path = oil.get_current_dir(0)
	local entry = oil.get_cursor_entry()
	if path and entry then
		local name = entry.name
		local parent_dir = vim.fn.fnamemodify(path, ":h") -- Get the parent directory
		local timestamp = os.date("%y%m%d%H%M%S") -- Append timestamp to avoid duplicates
		local zip_path = string.format("/tmp/%s_%s.zip", name, timestamp) -- Path in macOS's tmp directory
		-- Create the zip file
		local zip_cmd = string.format(
			"cd %s && zip -r %s %s",
			vim.fn.shellescape(parent_dir),
			vim.fn.shellescape(zip_path),
			vim.fn.shellescape(name)
		)
		local result = vim.fn.system(zip_cmd)
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed to create zip file: " .. result, vim.log.levels.ERROR)
			return
		end
		-- Copy the zip file to the system clipboard
		copy(zip_path)
	else
		vim.notify("No file or directory selected", vim.log.levels.WARN)
	end
end

local function selected_row_range()
	vim.cmd([[ execute "normal! \<ESC>" ]])
	local _, start_row, _, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, _, _ = unpack(vim.fn.getpos("'>"))

	return start_row, end_row
end

local function group_entries(start_row, end_row)
	local timestamp = os.date("%y%m%d%H%M%S") -- Append timestamp to avoid duplicates
	local tmp_dir_name = string.format("copy_%s", timestamp)
	local tmp_dir = string.format("/tmp/%s", tmp_dir_name)
	vim.fn.system(string.format("mkdir -p %s", tmp_dir))

	local path = oil.get_current_dir(0)

	for row = start_row, end_row do
		local entry = oil.get_entry_on_line(0, row)

		if entry then
			local escaped_path = vim.fn.fnameescape(path .. entry.parsed_name)
			local cmd = string.format("cp -R %s %s", escaped_path, tmp_dir)
			vim.fn.system(cmd)
		end
	end
	return tmp_dir
end

local function yank_current()
	yank_entry(oil.get_cursor_entry())
end

local function yank_selection()
	local start_row, end_row = selected_row_range()
	if start_row == end_row then
		yank_entry(oil.get_entry_on_line(0, start_row))
		return
	end
	copy(group_entries(start_row, end_row))
end

local function zip_selection()
	local start_row, end_row = selected_row_range()
	if start_row == end_row then
		yank_entry(oil.get_entry_on_line(0, start_row))
		return
	end
	local tmp_dir = group_entries(start_row, end_row)
	local dir = vim.fn.fnamemodify(tmp_dir, ":t:S")
	local zip_path = vim.fn.shellescape(string.format("%s.zip", tmp_dir))
	local zip_cmd = string.format("cd /tmp && zip -r %s %s", zip_path, dir)

	local result = vim.fn.system(zip_cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to create zip file: " .. result, vim.log.levels.ERROR)
		return
	end
	copy(zip_path)
end

local opts = { noremap = true, silent = true, buffer = 0 }

opts.desc = "Copy file or directory to clipboard"
vim.keymap.set("n", "yf", yank_current, opts)
vim.keymap.set("v", "yf", yank_selection, opts)

opts.desc = "Zip and copy to clipboard"
vim.keymap.set("n", "yz", zip_and_yank, opts)
vim.keymap.set("v", "yz", zip_selection, opts)
