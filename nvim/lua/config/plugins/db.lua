local function close_db()
	vim.cmd("DBUIClose")
	vim.cmd("tabclose")
end

vim.api.nvim_create_user_command("OpenDB", ":tabnew | DBUI", { nargs = 0 })
vim.api.nvim_create_user_command("CloseDB", close_db, { nargs = 0 })

return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		{ "catppuccin/nvim" },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
	end,
}
