local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight selection on yank",
	group = augroup("highlight_yank"),
	pattern = "*",
	callback = function()
		(vim.hl or vim.highlight).on_yank({ visual = true, timeout = 200 })
	end,
})
