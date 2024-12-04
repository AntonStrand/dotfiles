return {
  "nvimtools/none-ls.nvim",
  config = function()
    local none_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    none_ls.setup({
      sources = {
        none_ls.builtins.formatting.stylua,
        none_ls.builtins.formatting.elm_format,
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.formatting.fantomas,
        none_ls.builtins.formatting.shfmt,
        none_ls.builtins.formatting.clang_format,
        none_ls.builtins.formatting.gleam_format,
        none_ls.builtins.diagnostics.eslint_d,
      },

      on_attach = function(client, bufnr)
        -- Format on save
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(_client)
                  return client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })

    vim.keymap.set("n", "<leader>gf", ":Format<CR>", { desc = "Format code" })
  end,
}
