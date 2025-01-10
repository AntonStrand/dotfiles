local prefill_group = vim.api.nvim_create_augroup("prefill_group", {})

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = "*.elm",
  group = prefill_group,
  callback = require("antonstrand.core.prefill.elm").insert_module_name,
})

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = "*.fs",
  group = prefill_group,
  callback = require("antonstrand.core.prefill.fsharp").insert_template,
})
