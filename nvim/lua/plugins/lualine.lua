-- LSP STATUS

local function lsp_name()
	return vim.lsp.get_clients({ bufnr = 0 })[1].name or "No Active Lsp"
end

local function path()
	local pwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local sub_path = vim.fn.expand("%:~:.:h")

	if sub_path:match("oil") then
		local oil_pattern = "oil://" .. vim.fn.getcwd()
		sub_path = sub_path:gsub(oil_pattern, "")
	else
		pwd = pwd .. "/"
	end

	if sub_path:len() > 40 then
		return pwd .. vim.fn.pathshorten(sub_path)
	end
	return pwd .. sub_path
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		extensions = { "quickfix", "trouble", "oil" },
		config = function()
			local lualine = require("lualine")
			-- to configure lazy pending updates count
			local lazy_status = require("lazy.status")
			local mocha = require("catppuccin.palettes").get_palette("mocha")

			-- configure lualine with modified theme
			lualine.setup({
				options = {
					globalstatus = true,
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },

					-- Git status
					lualine_b = { "branch", "diff" },

					-- File path and status
					lualine_c = {
						{
							-- get_project_root,
							path,
							icon = " ",
							separator = "",
							color = { fg = mocha.overlay1 },
						},
						{
							"filetype",
							icon_only = true,
							padding = { left = 2, right = 0 },
						},
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 0, -- Only filename
							symbols = {
								newfile = "", -- Icon to show when the file is new.
								readonly = "", -- Icon to show when the file is read only.
								unnamed = "", -- No icon to show when the file is unnamed.
								modified = "", -- Icon to show when the file is modified.
							},
						},
						{
							"diagnostics",
							symbols = { error = "■ ", warn = "▲ ", info = "● ", hint = "◆ " },
						},
						{
							function()
								local bufnr = vim.api.nvim_get_current_buf()
								return require("arrow.statusline").text_for_statusline_with_icons(bufnr)
							end,
						},
						"trouble",
					},
					lualine_x = {
						{
							-- Show number of plugins that needs to be updated if there are any
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = mocha.maroon },
						},
					},
					lualine_y = {
						"filetype",
						{
							-- Show the current lsp
							icon = " ",
							lsp_name,
						},
						"progress",
					},
				},
			})
		end,
	},
}
