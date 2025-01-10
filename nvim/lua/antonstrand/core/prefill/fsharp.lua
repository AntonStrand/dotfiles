local utils = require("antonstrand.core.prefill.helpers")

local function is_domain_sweden()
  local cur_path = vim.fn.expand("%:h")
  return string.match(cur_path, "DomainSweden") ~= nil
end

local function create_template()
  local module_name = utils.create_module_name()
  if is_domain_sweden() then
    return { "namespace " .. module_name, "", utils.filename() .. " =" }
  else
    return { "module " .. module_name }
  end
end

local M = {}

M.insert_template = function(bufnr)
  local bufnr = bufnr or 0
  local template = create_template()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, template)
end

return M
