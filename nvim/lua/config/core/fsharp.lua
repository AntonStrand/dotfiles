local vim = vim

-- Ionide settings
vim.g["fsharp#show_signature_on_cursor_move"] = 0
vim.g["fsharp#lsp_auto_setup"] = 0
vim.g["fsharp#workspace_mode_peek_deep_level"] = 4
vim.g["fsharp#unnecessary_parentheses_analyzer"] = 1

vim.api.nvim_create_user_command("FSharpRefreshCodeLens", function()
	vim.lsp.codelens.refresh()
	print("[FSAC] Refreshing CodeLens")
end, {
	bang = true,
})
