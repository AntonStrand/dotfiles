local utils = require("config.core.prefill.helpers")

local M = {}

M.insert_module_name = function()
  local module_name = utils.create_module_name()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "module " .. module_name .. " exposing (..)" })
end

return M
