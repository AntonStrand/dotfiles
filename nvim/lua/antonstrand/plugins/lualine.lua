-- LSP STATUS

local function lsp_name()
	local name = "No Active Lsp"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_clients()
	if next(clients) == nil then
		return name
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return name
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
	-- Dependency to show copilot status in lualine.
	{ "AndreM222/copilot-lualine" },
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
					theme = "catppuccin",
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
						"diagnostics",
						{
							function()
								local bufnr = vim.api.nvim_get_current_buf()
								return require("arrow.statusline").text_for_statusline_with_icons(bufnr)
							end,
						},
					},
					lualine_x = {
						{
							"copilot",
							symbols = {
								status = {
									icons = {
										enabled = "",
										sleep = "",
										disabled = "",
										warning = "",
										unknown = "",
									},
									hl = {
										enabled = mocha.green,
										sleep = mocha.green,
										disabled = mocha.overlay0,
										warning = mocha.peach,
										unknown = mocha.red,
									},
								},
								spinners = require("copilot-lualine.spinners").dots,
								spinner_color = mocha.green,
							},
							show_colors = true,
							show_loading = true,
						},
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
