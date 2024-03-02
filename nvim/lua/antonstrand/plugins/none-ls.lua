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
				none_ls.builtins.diagnostics.eslint_d,
			},
		})

		vim.keymap.set("n", "<leader>gf", ":Format<CR>", { desc = "Format code" })
	end,
}
