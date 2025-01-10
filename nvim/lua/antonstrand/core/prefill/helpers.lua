local to_pascal_case = require("antonstrand.core.switch_case").to_pascal_case

local M = {}

M.format_path = function(path)
	return path:gsub("/([%w%d]+)", function(section)
		return to_pascal_case(section) .. "."
	end)
end

M.filename = function()
	return to_pascal_case(vim.fn.expand("%:t:r"))
end

M.create_module_name = function()
	local path = vim.fn.expand("%:h")
	local filename = M.filename()
	local module_path = string.gsub(path, "^[%w/]*src", "")

	if module_path ~= path then
		return M.format_path(module_path) .. filename
	else
		return filename
	end
end

return M
